extends Node3D

@export var is_3D: bool = false
@export var type: Global3D.PIECE_TYPE
@export var is_white: bool

var piece_mesh

var legal_moves = []

var square = {
	'column': '',
	'row': -1,
	'board': null,
}

var num_moves = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not is_3D:
		piece_mesh = load("res://peice_meshs/2D/2D_Mesh.tscn")
	else:
		match type:
			Global3D.PIECE_TYPE.pawn:
				piece_mesh = load("res://peGlobal3Dice_meshs/3D/pawn_mesh.tscn")
			Global3D.PIECE_TYPE.knight:
				piece_mesh = load("res://peice_meshs/3D/knight_mesh.tscn")
			Global3D.PIECE_TYPE.bishop:
				piece_mesh = load("res://peice_meshs/3D/bishop_mesh.tscn")
			Global3D.PIECE_TYPE.rook:
				piece_mesh = load("res://peice_meshs/3D/rook_mesh.tscn")
			Global3D.PIECE_TYPE.queen:
				piece_mesh = load("res://peice_meshs/3D/queen_mesh.tscn")
			Global3D.PIECE_TYPE.king:
				piece_mesh = load("res://peice_meshs/3D/king_mesh.tscn")
	var mesh = piece_mesh.instantiate()
	mesh.is_light = is_white
	if not is_3D:
		mesh.piece_type = type
	add_child(mesh)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func move_to(notation):
	Global3D.check_capture(notation)
	set_square(notation)
	update_position()
	num_moves = num_moves+1
	Global3D.move.emit()
	Global3D.change_turn()

func set_square(notation):
	square.column = notation.column
	square.row = notation.row
	square.board = notation.board

func update_position():
	var pos = Vector3(0, 0, 0)
	if Global3D.is_attack_board(square.board):
		for attack_board in Global3D.attack_board_instances:
			var dict = attack_board.get_attack_board_dict()
			if dict['board'] == square.board:
				print(dict)
				var col = abs('a'.unicode_at(0) - square.column.unicode_at(0))
				var row = square.row - 1
				pos = Global3D.translate_attk_boards(col, row, dict)
			pass
	else:
		pos = Global3D.translate(square.column, square.row, square.board)
	position.x = pos[0]
	position.z = pos[1]
	position.y = pos[2]

func is_on(notation):
	return Global3D.compare_square_notations(square, notation)

func get_legal_moves():
	legal_moves = PieceMovements3D.get_legal(type, is_white, square, num_moves)

func get_square():
	return square
