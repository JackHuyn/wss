extends Node3D

@export var piece_type: Global3D.PIECE_TYPE
@export var is_light: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var texturePath = null
	match piece_type:
		Global3D.PIECE_TYPE.pawn:
			if is_light:
				texturePath = "res://peice_meshs/2D/2D_pieces_textures/white/Chess_plt60.png"
			else:
				texturePath = "res://peice_meshs/2D/2D_pieces_textures/black/Chess_pdt60.png"
		Global3D.PIECE_TYPE.knight:
			if is_light:
				texturePath = "res://peice_meshs/2D/2D_pieces_textures/white/Chess_nlt60.png"
			else:
				texturePath = "res://peice_meshs/2D/2D_pieces_textures/black/Chess_ndt60.png"
		Global3D.PIECE_TYPE.bishop:
			if is_light:
				texturePath = "res://peice_meshs/2D/2D_pieces_textures/white/Chess_blt60.png"
			else:
				texturePath = "res://peice_meshs/2D/2D_pieces_textures/black/Chess_bdt60.png"
		Global3D.PIECE_TYPE.rook:
			if is_light:
				texturePath = "res://peice_meshs/2D/2D_pieces_textures/white/Chess_rlt60.png"
			else:
				texturePath = "res://peice_meshs/2D/2D_pieces_textures/black/Chess_rdt60.png"
		Global3D.PIECE_TYPE.queen:
			if is_light:
				texturePath = "res://peice_meshs/2D/2D_pieces_textures/white/Chess_qlt60.png"
			else:
				texturePath = "res://peice_meshs/2D/2D_pieces_textures/black/Chess_qdt60.png"
		Global3D.PIECE_TYPE.king:
			if is_light:
				texturePath = "res://peice_meshs/2D/2D_pieces_textures/white/Chess_klt60.png"
			else:
				texturePath = "res://peice_meshs/2D/2D_pieces_textures/black/Chess_kdt60.png"
	apply_texture($MeshInstance3D, texturePath)
	position.y += 0.1

func apply_texture(mesh_instance_node, texture_path) -> void:
	# duplicates material to make each material independant.
	var image = load(texture_path)
	var material = mesh_instance_node.get_active_material(0).duplicate()
	
	# Set albedo texture as the piece.png
	material.albedo_texture = image
	
	# Set the piece material as the new duplicated material 
	mesh_instance_node.set_surface_override_material(0, material)
