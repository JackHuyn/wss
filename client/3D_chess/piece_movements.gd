extends Node

var _knight
var _pawn
var _rook_bishop_queen_king

func _ready() -> void:
	var movement_script = load("res://3D_chess/piece_movement_scripts/knight_movement.gd")
	_knight = movement_script.new()
	movement_script = load("res://3D_chess/piece_movement_scripts/pawn_movement.gd")
	_pawn = movement_script.new()
	movement_script = load("res://3D_chess/piece_movement_scripts/rook_bishop_queen_king_movement.gd")
	_rook_bishop_queen_king = movement_script.new()

func get_legal(
		type, is_white, curr_notation, # mandetory
		num_moves : int = 0 # optional
	):
	match type:
		Global3D.PIECE_TYPE.pawn:
			return _pawn.get_legal_squares(is_white, curr_notation, num_moves)
		Global3D.PIECE_TYPE.knight:
			return _knight.get_legal_squares(is_white, curr_notation, num_moves)
		_:
			# the queen the rook the bishop and the king use the same script
			return _rook_bishop_queen_king.get_legal_squares(is_white, curr_notation, num_moves, type)

# get squares with overlapping notations
func get_notation_overlap(notation, over_under):
	# over_under: true for on top false for under
	if Global3D.square_exists(notation):
		var square = Global3D.get_square_instance(notation)
		var overlapping_squares = square.get_overlap(over_under)
		return overlapping_squares

# get the dictionary of a connected attack board
func get_connected_attackboard(ab_dict):
	# if attack board is up then the connected attackboard can only be
	# on the main level above it positioned down or under it
	var connect_ab_dict = null
	var main_board = ab_dict.corner_square.board
	if ab_dict.is_up:
		# white board = 0, nutral = 1, black = 2
		# go to higher board
		main_board += 1
		for b in Global3D.attack_board_instances:
			var board_dict = b.get_attack_board_dict();
			if (
				# the main board needs to match
				board_dict.corner_square.board == main_board
				# needs to be down
				#and not board_dict.is_up
				and Global3D.get_ab_color(board_dict) != Global3D.get_ab_color(ab_dict)
			):
				connect_ab_dict = board_dict
	else:
		# go lower
		main_board -= 1
		for b in Global3D.attack_board_instances:
			var board_dict = b.get_attack_board_dict();
			if (
				# the main board needs to match
				board_dict.corner_square.board == main_board
				# needs to be up
				and board_dict.is_up
				and Global3D.get_ab_color(board_dict) != Global3D.get_ab_color(ab_dict)
			):
				connect_ab_dict = board_dict
	print(ab_dict, connect_ab_dict)
	return connect_ab_dict

# adding a square based on wether or not you want to capture it
func add_square(legal_squares, capture, notation, curr_piece_color):
	var piece = Global3D.check_square(notation)
	if (!piece and !capture) or (capture and piece):
		if capture and piece.is_white == curr_piece_color:
			# if we are capturing and the pieces are the same color
			return false
		legal_squares.push_front(notation)
		return true
	return false

# this is a function used in movment scripts to add all of the overlapping squares
# until reaching a capturable square at which point it stops
func add_overlap_squares(legal_squares, notation, curr_piece_color):
	# squars over it
	var overlapping_squares = get_notation_overlap(notation, true)
	add_until(legal_squares, overlapping_squares, curr_piece_color)
	# squares under it
	overlapping_squares = get_notation_overlap(notation, false)
	add_until(legal_squares, overlapping_squares, curr_piece_color)

# keeps adding the squares until it gets to one that cant go in
func add_until(legal_squares, squares, curr_piece_color):
	for square in squares:
		if not add_square(legal_squares, false, square.get_notation(), curr_piece_color):
			# if you cant go try capturing and then break
			add_square(legal_squares, true, square.get_notation(), curr_piece_color)
			break
