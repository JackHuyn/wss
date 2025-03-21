extends Node

#------------------- Type Definitions ------------------------

enum BOARD_TYPE {
	WHITE,
	NEUTRAL,
	BLACK,
	WHITE_K_ATTACK,
	WHITE_Q_ATTACK,
	BLACK_K_ATTACK,
	BLACK_Q_ATTACK,
}

enum PIECE_TYPE {
	pawn,
	knight,
	bishop,
	rook,
	queen,
	king
}

#------------------- Translate Functions ------------------------

var main_board_size = 4
var attack_board_size = 2

func translate(column, row, board_type):
	# the column param in this function is in char
	var zOffset
	var yOffset
	
	if(board_type == BOARD_TYPE.WHITE):
		zOffset = -2
		yOffset = -2
	elif (board_type == BOARD_TYPE.NEUTRAL):
		zOffset = 0
		yOffset = 0
	elif (board_type == BOARD_TYPE.BLACK):
		zOffset = 2
		yOffset = 2
	else:
		yOffset = 0
		zOffset = 0
		print("Invalid Board Type")
	
	# the 1.5 values are to center the boards
	var x = -('a'.unicode_at(0)-column.unicode_at(0)+1.5)
	var z = -(row-4)-zOffset-1.5
	var y = yOffset
	return [x,z,y]

func translate_attk_boards(column, row, board_dict):
	# one thing to remember is that column in this function is in unicode
	var x = 0
	var z = 0
	var y = 0
	var pos = translate(board_dict['corner_square']['column'], board_dict['corner_square']['row'],
	 board_dict['corner_square']['board'])
	#we want the boards to hang off the edge. so...
	if(board_dict['corner_square']['column'] == 'a'):
		x = pos[0] + column - 1
	else:
		x = pos[0] + column
	if(board_dict['corner_square']['row'] == 1):
		z = pos[1] - row + 1
	else:
		z = pos[1] - row
	#handle y axis
	if(board_dict['is_up'] == true):
		y = pos[2] + 1
	else:
		y = pos[2] - 1
	return [x,z,y]

#------------------- Game State ------------------------

var game_state = {
	'is_white_turn': true,
	'player_color': null,
	'selected_attack_board': null,
	'selected_piece': null, # will need later
}

# an array of the attackB ditionariys
var attack_boards = [
	{
		'board': BOARD_TYPE.WHITE_Q_ATTACK,
		'corner_square': {
			'column': 'a',
			'row': 1,
			'board': BOARD_TYPE.WHITE,
		},
		'is_up': false,
	},
	
	{
	'board': BOARD_TYPE.WHITE_K_ATTACK,
		'corner_square': {
			'column': 'd',
			'row': 1,       
			'board': BOARD_TYPE.WHITE, 
		},
	'is_up': false,  # Maybe this board is currently active
	},
	
	{
	'board': BOARD_TYPE.BLACK_Q_ATTACK,
		'corner_square': {
			'column': 'a',
			'row': 4,       
			'board': BOARD_TYPE.BLACK, 
		},
	'is_up': true,  # Maybe this board is currently active
	},
	
	{
	'board': BOARD_TYPE.BLACK_K_ATTACK,
		'corner_square': {
			'column': 'd',
			'row': 4,       
			'board': BOARD_TYPE.BLACK, 
		},
	'is_up': true,  # Maybe this board is currently active
	}
]

# actual game nodes of the attack boards
var attack_board_instances = []

# actual game node of pieces
var piece_list = []

func change_turn():
	game_state.is_white_turn = !game_state.is_white_turn

func hide_highlights():
	for square in get_tree().get_nodes_in_group("square"):
		square.get_child(1).visible = false
		square.get_child(2).visible = false

func highlight_squares(legal_squares):
	for square in get_tree().get_nodes_in_group("square"):
		if square.get_notation() in legal_squares:
			if check_square(square.get_notation()):
				square.get_child(2).visible = true
			else:
				square.get_child(1).visible = true

# functionality for ending the game
signal game_over
var _winner = null

#------------------- Sound Effect Signals --------------------------

# the functions connected to these sigansl are in the sound_effects script
signal capture
signal move
signal notify

#------------------- Piece Movement Helpers ------------------------

func check_square(notation):
	for i in range(piece_list.size()):
		if piece_list[i].is_on(notation):
			return piece_list[i]
	return null

func compare_square_notations(notation_1, notation_2):
	if notation_1.column==notation_2.column and notation_1.row==notation_2.row and notation_1.board==notation_2.board:
		return true
	return false

func check_capture(notation):
	for i in range(piece_list.size()):
		if piece_list[i].is_on(notation):
			piece_list[i].queue_free()
			var removed_piece = piece_list[i]
			piece_list.remove_at(i)
			emit_signal("capture")
			if removed_piece.type == PIECE_TYPE.king:
				_winner = not removed_piece.is_white
				emit_signal("game_over")
				piece_list.remove_at(i)
			break

func update_pieces(board):
	for piece in piece_list:
		if piece.get_square().board == board:
			print("update_pieces")
			piece.update_position()

func square_exists(square):
	if is_attack_board(square.board):
		if (
			square.column>='a' and square.column<='b' and 
			square.row>0 and square.row<3
		):
			return true
		return false
	if (
		square.column>='a' and square.column<='d' and 
		square.row>0 and square.row<5
	):
		return true
	return false

func get_square_instance(notation):
	var all_squares = get_tree().get_nodes_in_group("square")
	for square in all_squares:
		if compare_square_notations(notation, square.get_notation()):
			return square

#------------------- Attack Board Helpers ------------------------

func remove_board_by_id(board_id: int) -> void:
	for i in range(attack_board_instances.size()):
		var current_board = attack_board_instances[i]
		 # Check if the current board matches the given ID
		if current_board.id == board_id:
			# Remove the board from the scene tree
			current_board.queue_free()
			# Remove the board from the array
			attack_board_instances.remove_at(i)
			return  # Exit after removing the boad

func is_attack_board(board_type):
	var is_ab = (
		board_type == BOARD_TYPE.WHITE_K_ATTACK or
		board_type == BOARD_TYPE.BLACK_K_ATTACK or
		board_type == BOARD_TYPE.WHITE_Q_ATTACK or
		board_type == BOARD_TYPE.BLACK_Q_ATTACK
	)
	return is_ab

func compare_ab_move(move_1, move_2):
	var is_equal = (
		move_1['column'] == move_2['column'] and
		move_1['row'] == move_2['row'] and
		move_1['board'] == move_2['board'] and
		move_1['is_up'] == move_2['is_up']
	)
	return is_equal

func is_corner_occupied(entry: Dictionary) -> bool:
		var attack_boards = attack_board_instances
		for attack_board in attack_boards:
			var corner_square = attack_board.attack_board_dict['corner_square']
			# Check if the entry matches the corner square's board, column, and row
			if corner_square['board'] == entry['board'] and corner_square['column'] == entry['column'] and corner_square['row'] == entry['row']:
				# Compare the is_up value
				return attack_board.attack_board_dict['is_up'] == entry['is_up']
		return false

func get_ab_color(ab_dict):
	var board = ab_dict.board
	if board > 2 and board < 5:
		# true for white
		return true
	if board > 4 and board <7:
		# false for black
		return false
	# null for not a attackboard
	return null
