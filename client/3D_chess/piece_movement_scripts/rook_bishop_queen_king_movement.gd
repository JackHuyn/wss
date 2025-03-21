class_name RBQMovement

func get_legal_squares(is_white, curr_notation, num_moves, type):
	var legal_squares = []
	var visited = {} #track visited squares
	var directions = null
	if type==Global3D.PIECE_TYPE.bishop:
		directions = [Vector2(1, 1), Vector2(-1, -1), Vector2(-1, 1), Vector2(1, -1)]
	elif type==Global3D.PIECE_TYPE.rook:
		directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
	else:
		directions = [
			Vector2(1, 1), Vector2(-1, -1), Vector2(-1, 1), Vector2(1, -1),
			Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)
		]
	var queue = []
	
	var curr_overlap = _get_initial_overlap(curr_notation, is_white)

	for d in directions:
		for notation in curr_overlap:
			var start_col_code = notation["column"].unicode_at(0)
			var start_row = notation["row"]
			var next_notation = {
				"column": String.chr(start_col_code + int(d.x)),
				"row": start_row + int(d.y),
				"board": notation["board"]
			}
			if Global3D.square_exists(next_notation):
				queue.append({"notation": next_notation, "direction": d})
	
	while queue.size() > 0:
		var item = queue[0]
		queue.pop_front()
		var notation = item["notation"]
		var dir = item["direction"]
		#unique key
		var key = str(notation["column"]) + "|" + str(notation["row"]) + "|" + str(notation["board"])

		if visited.has(key): #skip is it's a visited square
			continue
		visited[key] = true
		if not Global3D.square_exists(notation):
			continue

		var piece = Global3D.check_square(notation)
		if piece:
			if piece.is_white != is_white: #capture enemy piece
				legal_squares.append(notation)
			continue
		else:
			legal_squares.append(notation)
			var col_code = notation["column"].unicode_at(0)
			var row = notation["row"]
			var next_in_line = { #next square  in same direction
				"column": String.chr(col_code + int(dir.x)),
				"row": row + int(dir.y),
				"board": notation["board"]
			}
			if Global3D.square_exists(next_in_line) and Global3D.PIECE_TYPE.king!=type:
				queue.append({"notation": next_in_line, "direction": dir})
		
		#move up to higher board
		var overlaps_above = PieceMovements3D.get_notation_overlap(notation, true)
		for osq in overlaps_above:
			var o_notation = osq.get_notation()
			var o_key = str(o_notation["column"]) + "|" + str(o_notation["row"]) + "|" + str(o_notation["board"])
			if not visited.has(o_key) and Global3D.square_exists(o_notation):
				queue.append({"notation": o_notation, "direction": dir})
		
		#move down to lower board
		var overlaps_below = PieceMovements3D.get_notation_overlap(notation, false)
		for osq in overlaps_below:
			var o_notation = osq.get_notation()
			var o_key = str(o_notation["column"]) + "|" + str(o_notation["row"]) + "|" + str(o_notation["board"])
			if not visited.has(o_key) and Global3D.square_exists(o_notation):
				queue.append({"notation": o_notation, "direction": dir})
	if type!=Global3D.PIECE_TYPE.bishop:
		PieceMovements3D.add_overlap_squares(legal_squares, curr_notation, is_white)
	return legal_squares

func _get_initial_overlap(curr_notation, is_white):
	var overlaps = [curr_notation]
	var over = PieceMovements3D.get_notation_overlap(curr_notation, true)
	for square in over:
		var notation = square.get_notation()
		var piece = Global3D.check_square(notation)
		if piece:
			if piece.is_white!=is_white:
				overlaps.push_back(notation)
			break
		overlaps.push_back(notation)
	var under = PieceMovements3D.get_notation_overlap(curr_notation, false)
	for square in under:
		var notation = square.get_notation()
		var piece = Global3D.check_square(notation)
		if piece:
			if piece.is_white!=is_white:
				overlaps.push_front(notation)
			break
		overlaps.push_front(notation)
	return overlaps
