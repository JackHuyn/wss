# This class is to help with piece movment
# speicifcally whith connected attack boards
class_name PsudoBoard

# board one comes before board 2 in the world space
var board_1
# board 2 comes after board 1
var board_2

func _init(board_dicts) -> void:
	var temp_position_1 = Global3D.translate_attk_boards('a'.unicode_at(0),1,board_dicts[0])
	var temp_position_2 = Global3D.translate_attk_boards('a'.unicode_at(0),1,board_dicts[1])
	print("temp poritions", temp_position_1, temp_position_2)
	# compare z
	if temp_position_1[1] > temp_position_2[1]:
		board_1 = board_dicts[0]
		board_2 = board_dicts[1]
	else:
		board_1 = board_dicts[1]
		board_2 = board_dicts[0]
	print("Board 1:", board_1)

func get_psudo_notation(square_notation):
	# need to duplicate the square column
	var column = String.chr(square_notation.column.unicode_at(0))
	# then calcualte the row based on the board its on
	var row
	if square_notation.board == board_1.board:
		row = square_notation.row
	else:
		row = square_notation.row + 2
	return {
		'column': column,
		'row': row,
	}

func get_actual_notation(psudo_notation):
	# just to be safe duplicating the column again
	var column = String.chr(psudo_notation.column.unicode_at(0))
	var row = psudo_notation.row
	var board = board_1.board
	if row > 2:
		row = row-2
		board = board_2.board
	return {
		'column': column,
		'row': row,
		'board': board,
	}
