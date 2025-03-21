extends Node3D

@export var board_type: Global3D.BOARD_TYPE
@export var square_prefab: PackedScene = preload("res://3D_chess/square.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var isStartLight = false
	for col in Global3D.main_board_size:
		var column = char(col+97)
		var isLight = isStartLight
		for r in Global3D.main_board_size:
			var row = r+1
			var s = square_prefab.instantiate()
			s.isWhite = isLight
			var coord = Global3D.translate(column, row, board_type)
			s.position.x = coord[0]
			s.position.z = coord[1]
			s.position.y = coord[2]
			s.set_notation(column, row, board_type)
			isLight = !isLight
			add_child(s)
		isStartLight = !isStartLight
