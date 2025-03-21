extends Node3D

@export var square_prefab: PackedScene = preload("res://3D_chess/square.tscn")
var ab_movments = load("res://3D_chess/attack_board_movment.gd").new()

# make dict of the vars
var attack_board_dict
var id
var pieces_on_board = []

var possible_attack_board_moves = []
var commanding_pieces = {
	'has_bisop' : false,
	'has_knight' : false,
	'has_rook' : false,
	'has_queen' : false,
	'has_king' : false
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(attack_board_dict == null):
		print("attack board is null!")
	var s
	var isStartLight = false
	for col in range(2):
		var isLight = isStartLight
		for row in range(2):
			s = square_prefab.instantiate()
			s.isWhite = isLight
			var xzy = Global3D.translate_attk_boards(col,row,attack_board_dict)
			s.position.x = xzy[0]
			s.position.z = xzy[1]
			s.position.y = xzy[2]
			s.set_notation(char(col+97), row+1, attack_board_dict['board'])
			isLight = !isLight
			add_child(s)
		isStartLight = !isStartLight

func get_Color():
	return determin_owner()

func determin_owner():
	
	update_commanding()
	if pieces_on_board.is_empty():
		return null
	var first_piece_color = pieces_on_board[0].is_white
	for piece in pieces_on_board:
		if piece.is_white != first_piece_color:
			return null
	return first_piece_color


func update_pieces_on_board():
	pieces_on_board = []
	for piece in Global3D.piece_list:
		if(piece['square']['board'] == attack_board_dict['board']):
			pieces_on_board.append(piece)


func update_commanding():
	
	update_pieces_on_board()
	
	for piece in pieces_on_board:
			
		var piece_type = piece['type']
		
		match piece_type:
			Global3D.PIECE_TYPE.bishop:
				commanding_pieces['has_bisop'] = true
			Global3D.PIECE_TYPE.rook:
				commanding_pieces['has_rook'] = true
			Global3D.PIECE_TYPE.knight:
				commanding_pieces['has_knight'] = true
			Global3D.PIECE_TYPE.queen:
				commanding_pieces['has_queen'] = true
			Global3D.PIECE_TYPE.king:
				commanding_pieces['has_king'] = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_attack_board_dict():
	return attack_board_dict

func set_attack_board_dict(dict_in):
	attack_board_dict = dict_in
	determin_owner()

func print_attack_board_dict():
	print("id: ", id)
	for ab in attack_board_dict:
		print(ab)

func update_legal_moves():
	var possible_moves_list = []
	print("updateing legal moves")
	# TODO: I think there is a better way of doing this will explore later
	if(commanding_pieces.has_queen):
		possible_moves_list += ab_movments.queen_movment(attack_board_dict)
	if(commanding_pieces.has_knight):
		possible_moves_list += ab_movments.knight_movment(attack_board_dict)
	if(commanding_pieces.has_rook):
		possible_moves_list += ab_movments.rook_movment(attack_board_dict)
	if(commanding_pieces.has_bisop):
		possible_moves_list += ab_movments.bishop_movment(attack_board_dict)
	if(commanding_pieces.has_king):
		possible_moves_list += ab_movments.king_movment(attack_board_dict)
	
	possible_attack_board_moves = possible_moves_list
	print("possible moves list is:")
	print_possible_move_list()

func get_legal_moves():
	return possible_attack_board_moves

func is_move_legal(move_in: Dictionary) -> bool:
	for move in possible_attack_board_moves:
		# Check if the move matches the provided move_in dictionary
		if Global3D.compare_ab_move(move,move_in):
			return true  # Move is legal
	return false  # Move is not legal

func print_possible_move_list():
	for ab in possible_attack_board_moves:
		print(ab)

func update_commanding_pieces():
	pass

func get_pieces():
	pass
