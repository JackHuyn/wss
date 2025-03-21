class_name KnightMovement

var _offsets = [
	Vector2(2, 1), Vector2(2, -1), Vector2(-2, 1), Vector2(-2, -1),
	Vector2(1, 2), Vector2(1, -2), Vector2(-1, 2), Vector2(-1, -2)
]

func get_legal_squares(is_white, curr_notation, space_state):
	var legal_squares = []
	var queue = []
	var initial_overlaps = _get_overlap(curr_notation)
	for notation in initial_overlaps:
		for offset in _offsets:
			queue.push_back({"notation": notation, "offset": offset})
	while not queue.is_empty():
		var element = queue.pop_front()
		var notation = element.notation
		var offset_x = element.offset.x
		var offset_y = element.offset.y
		if abs(offset_x)>0:
			var col = notation.column.unicode_at(0)
			var row = notation.row
			var board = notation.board
			if offset_x>0:
				col += 1
				offset_x -= 1
			else:
				col -= 1
				offset_x += 1
			_add_queue(queue, col, row, board, offset_x, offset_y)
		offset_x = element.offset.x
		offset_y = element.offset.y
		if abs(offset_y)>0:
			var col = notation.column.unicode_at(0)
			var row = notation.row
			var board = notation.board
			if offset_y>0:
				row += 1
				offset_y -= 1
			else:
				row -= 1
				offset_y += 1
			_add_queue(queue, col, row, board, offset_x, offset_y)
		if element.offset.length_squared()==0:
			var piece = Global3D.check_square(notation)
			if piece:
				if piece.is_white != is_white:
					legal_squares.push_back(notation)
			else:
				legal_squares.push_back(notation)
			continue
	return legal_squares

func _add_queue(queue, col, row, board, offset_x, offset_y):
	var new_notation = {
		"column": String.chr(col),
		"row": row,
		"board": board
	}
	var new_offset = Vector2(offset_x, offset_y)
	var new_overlaps = _get_overlap(new_notation)
	for n in new_overlaps:
		queue.push_back({"notation": n, "offset": new_offset})

func _get_overlap(notation):
	if Global3D.square_exists(notation):
		var overlaps = [notation]
		var overlap_instances = PieceMovements3D.get_notation_overlap(notation, true) + PieceMovements3D.get_notation_overlap(notation, false)
		for square in overlap_instances:
			overlaps.push_back(square.get_notation())
		return overlaps
	return []
