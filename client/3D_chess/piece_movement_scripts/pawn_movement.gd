class_name PawnMovement

var PsudoBoard = load("res://3D_chess/psudo_board.gd")

func get_legal_squares(is_white, curr_notation, num_moves):
	var col = curr_notation.column.unicode_at(0)
	var r = curr_notation.row
	var board = curr_notation.board
	var direction = 1
	var over_under = true
	if !is_white:
		direction = -1
	var legal_squares = []
	PieceMovements3D.add_overlap_squares(legal_squares, curr_notation, is_white)
	var temp_notation = {
		'column': String.chr(col),
		'row': r+direction,
		'board': board,
	}
	var first_push_success = PieceMovements3D.add_square(legal_squares, false, temp_notation, is_white)
	var capture_squares = [
		{
			'column': String.chr(col-1),
			'row': r+direction,
			'board': board,
		},
		{
			'column': String.chr(col+1),
			'row': r+direction,
			'board': board,
		},
	]
	for capture_square in capture_squares:
		PieceMovements3D.add_square(legal_squares, true, capture_square, is_white)
	if num_moves<1 and first_push_success:
		temp_notation = {
			'column': String.chr(col),
			'row': r+direction*2,
			'board': board,
		}
		PieceMovements3D.add_square(legal_squares, false, temp_notation, is_white)
	# squares on connected attack boards
	if Global3D.is_attack_board(board):
		var curr_b = Global3D.get_square_instance(curr_notation).get_parent().attack_board_dict
		var connected_b = PieceMovements3D.get_connected_attackboard(curr_b)
		if connected_b:
			var psudo_board = PsudoBoard.new([curr_b,connected_b])
			var curr_psudo_notation = psudo_board.get_psudo_notation(curr_notation)
			curr_psudo_notation.row += direction
			print("psudo notation", curr_psudo_notation)
			if curr_psudo_notation.row<5 and curr_psudo_notation.row>0:
				var temp_square = psudo_board.get_actual_notation(curr_psudo_notation)
				PieceMovements3D.add_square(legal_squares, false, temp_square, is_white)
				if num_moves<1:
					curr_psudo_notation.row += direction
					# this also duplicates the notation
					temp_square = psudo_board.get_actual_notation(curr_psudo_notation)
					PieceMovements3D.add_square(legal_squares, false, temp_square, is_white)
			curr_psudo_notation = psudo_board.get_psudo_notation(curr_notation)
			var psudo_capture_squares = [
				{
					'column': String.chr(curr_psudo_notation.column.unicode_at(0)-1),
					'row': curr_psudo_notation.row+direction,
				},
				{
					'column': String.chr(curr_psudo_notation.column.unicode_at(0)+1),
					'row': curr_psudo_notation.row+direction,
				},
			]
			for psudo_capture_square in psudo_capture_squares:
				var temp_square = psudo_board.get_actual_notation(psudo_capture_square)
				PieceMovements3D.add_square(legal_squares, true, temp_square, is_white)
				pass
	return legal_squares
