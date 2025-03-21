extends Node3D

@export var isWhite: bool

var notation = {
	'column': '',
	'row': -1,
	'board': Global3D.BOARD_TYPE.WHITE,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("square")
	if isWhite:
		$MeshInstance3D.material_override = preload("res://white_square_material.tres")
	else:
		$MeshInstance3D.material_override = preload("res://black_square_material.tres")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_overlap(over_under):
	# over_under: true for squares ontop and false for under
	var squares = []
	var space_state = get_world_3d().direct_space_state
	var origin = global_position
	var vec = Vector3(0, -1, 0)
	if over_under:
		vec = Vector3(0, 1, 0)
	while true:
		var end = origin + vec * 9
		var ray_query = PhysicsRayQueryParameters3D.create(origin, end)
		var intersection = space_state.intersect_ray(ray_query)
		if intersection:
			var obj = intersection["collider"].get_parent().get_parent()
			if obj.is_in_group("square") and not Global3D.compare_square_notations(obj.get_notation(), notation):
				# order matters here
				squares.push_back(obj)
			origin = intersection["collider"].global_position
		else:
			break
	return squares

func set_notation(col, r, board_type):
	notation.column = col
	notation.row = r
	notation.board = board_type

func get_notation():
	return notation

func print_notation():
	var board_string = ''
	match notation.board:
		Global3D.BOARD_TYPE.WHITE:
			board_string = 'W'
		Global3D.BOARD_TYPE.BLACK:
			board_string = 'B'
		Global3D.BOARD_TYPE.NEUTRAL:
			board_string = 'N'
		Global3D.BOARD_TYPE.WHITE_K_ATTACK:
			board_string = 'WKA'
		Global3D.BOARD_TYPE.WHITE_Q_ATTACK:
			board_string = 'WQA'
		Global3D.BOARD_TYPE.BLACK_K_ATTACK:
			board_string = 'BKA'
		Global3D.BOARD_TYPE.BLACK_Q_ATTACK:
			board_string = 'BQA'
	print(board_string, notation.column, notation.row)
