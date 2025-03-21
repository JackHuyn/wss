extends Node3D

@export var board_prefab: PackedScene
@export var attack_board_prefab : PackedScene
@export var camera: Camera3D
@export var piece_prefab: PackedScene
@onready var parent = get_node("/root/main")


func CreateBoards():
	var numb_boards = 3
	var b
	#Main boards
	for board in numb_boards:
		b = board_prefab.instantiate()
		if(board == 0):
			b.board_type = Global3D.BOARD_TYPE.WHITE
		elif (board == 1):
			b.board_type = Global3D.BOARD_TYPE.NEUTRAL
		elif (board == 2):
			b.board_type = Global3D.BOARD_TYPE.BLACK
		add_child(b)
	var count = 1
	#Attack boards
	for a_b in range(len(Global3D.attack_boards)):
		b = attack_board_prefab.instantiate()
		b.id = count
		count += 1
		b.set_attack_board_dict(Global3D.attack_boards[a_b])
		
		add_child(b)
		Global3D.attack_board_instances.append(b)

func create_pieces():
	var initial_piece_state = [] # just notations
	
	# White Fixed Level
	initial_piece_state.append_array([
		{
			'type': Global3D.PIECE_TYPE.pawn,
			'square': { 'column': 'a', 'row': 2, 'board': Global3D.BOARD_TYPE.WHITE },
			'is_white': true
		},
		{
			'type': Global3D.PIECE_TYPE.pawn,
			'square': { 'column': 'b', 'row': 2, 'board': Global3D.BOARD_TYPE.WHITE },
			'is_white': true
		},
		{
			'type': Global3D.PIECE_TYPE.pawn,
			'square': { 'column': 'c', 'row': 2, 'board': Global3D.BOARD_TYPE.WHITE },
			'is_white': true
		},
		{
			'type': Global3D.PIECE_TYPE.pawn,
			'square': { 'column': 'd', 'row': 2, 'board': Global3D.BOARD_TYPE.WHITE },
			'is_white': true
		},
		{
			'type': Global3D.PIECE_TYPE.bishop,
			'square': { 'column': 'a', 'row': 1, 'board': Global3D.BOARD_TYPE.WHITE },
			'is_white': true
		},
		{
			'type': Global3D.PIECE_TYPE.bishop,
			'square': { 'column': 'd', 'row': 1, 'board': Global3D.BOARD_TYPE.WHITE },
			'is_white': true
		},
		{
			'type': Global3D.PIECE_TYPE.queen,
			'square': { 'column': 'b', 'row': 1, 'board': Global3D.BOARD_TYPE.WHITE },
			'is_white': true
		},
		{
			'type': Global3D.PIECE_TYPE.king,
			'square': { 'column': 'c', 'row': 1, 'board': Global3D.BOARD_TYPE.WHITE },
			'is_white': true
		},
	])
	
	# White King Attack Platform (L)
	initial_piece_state.append_array([
		{
			'type': Global3D.PIECE_TYPE.pawn,
			'square': { 'column': 'a', 'row': 2, 'board': Global3D.BOARD_TYPE.WHITE_K_ATTACK },
			'is_white': true
		},
		{
			'type': Global3D.PIECE_TYPE.pawn,
			'square': { 'column': 'b', 'row': 2, 'board': Global3D.BOARD_TYPE.WHITE_K_ATTACK },
			'is_white': true
		},
		{
			'type': Global3D.PIECE_TYPE.rook,
			'square': { 'column': 'b', 'row': 1, 'board': Global3D.BOARD_TYPE.WHITE_K_ATTACK },
			'is_white': true
		},
		{
			'type': Global3D.PIECE_TYPE.knight,
			'square': { 'column': 'a', 'row': 1, 'board': Global3D.BOARD_TYPE.WHITE_K_ATTACK },
			'is_white': true
		},
	])
	
	# White Queen Attack Platform (R)
	initial_piece_state.append_array([
		{
			'type': Global3D.PIECE_TYPE.pawn,
			'square': { 'column': 'a', 'row': 2, 'board': Global3D.BOARD_TYPE.WHITE_Q_ATTACK },
			'is_white': true
		},
		{
			'type': Global3D.PIECE_TYPE.pawn,
			'square': { 'column': 'b', 'row': 2, 'board': Global3D.BOARD_TYPE.WHITE_Q_ATTACK },
			'is_white': true
		},
		{
			'type': Global3D.PIECE_TYPE.knight,
			'square': { 'column': 'b', 'row': 1, 'board': Global3D.BOARD_TYPE.WHITE_Q_ATTACK },
			'is_white': true
		},
		{
			'type': Global3D.PIECE_TYPE.rook,
			'square': { 'column': 'a', 'row': 1, 'board': Global3D.BOARD_TYPE.WHITE_Q_ATTACK },
			'is_white': true
		},
	])
	
	# Black Fixed Level
	initial_piece_state.append_array([
		{
			'type': Global3D.PIECE_TYPE.pawn,
			'square': { 'column': 'a', 'row': 3, 'board': Global3D.BOARD_TYPE.BLACK },
			'is_white': false
		},
		{
			'type': Global3D.PIECE_TYPE.pawn,
			'square': { 'column': 'b', 'row': 3, 'board': Global3D.BOARD_TYPE.BLACK },
			'is_white': false
		},
		{
			'type': Global3D.PIECE_TYPE.pawn,
			'square': { 'column': 'c', 'row': 3, 'board': Global3D.BOARD_TYPE.BLACK },
			'is_white': false
		},
		{
			'type': Global3D.PIECE_TYPE.pawn,
			'square': { 'column': 'd', 'row': 3, 'board': Global3D.BOARD_TYPE.BLACK },
			'is_white': false
		},
		{
			'type': Global3D.PIECE_TYPE.bishop,
			'square': { 'column': 'a', 'row': 4, 'board': Global3D.BOARD_TYPE.BLACK },
			'is_white': false
		},
		{
			'type': Global3D.PIECE_TYPE.bishop,
			'square': { 'column': 'd', 'row': 4, 'board': Global3D.BOARD_TYPE.BLACK },
			'is_white': false
		},
		{
			'type': Global3D.PIECE_TYPE.queen,
			'square': { 'column': 'b', 'row': 4, 'board': Global3D.BOARD_TYPE.BLACK },
			'is_white': false
		},
		{
			'type': Global3D.PIECE_TYPE.king,
			'square': { 'column': 'c', 'row': 4, 'board': Global3D.BOARD_TYPE.BLACK },
			'is_white': false
		},
	])
	
	# Black King Attack Platform (L)
	initial_piece_state.append_array([
		{
			'type': Global3D.PIECE_TYPE.pawn,
			'square': { 'column': 'a', 'row': 1, 'board': Global3D.BOARD_TYPE.BLACK_K_ATTACK },
			'is_white': false
		},
		{
			'type': Global3D.PIECE_TYPE.pawn,
			'square': { 'column': 'b', 'row': 1, 'board': Global3D.BOARD_TYPE.BLACK_K_ATTACK },
			'is_white': false
		},
		{
			'type': Global3D.PIECE_TYPE.rook,
			'square': { 'column': 'b', 'row': 2, 'board': Global3D.BOARD_TYPE.BLACK_K_ATTACK },
			'is_white': false
		},
		{
			'type': Global3D.PIECE_TYPE.knight,
			'square': { 'column': 'a', 'row': 2, 'board': Global3D.BOARD_TYPE.BLACK_K_ATTACK },
			'is_white': false
		},
	])
	
	# Black Queen Attack Platform (R)
	initial_piece_state.append_array([
		{
			'type': Global3D.PIECE_TYPE.pawn,
			'square': { 'column': 'a', 'row': 1, 'board': Global3D.BOARD_TYPE.BLACK_Q_ATTACK },
			'is_white': false
		},
		{
			'type': Global3D.PIECE_TYPE.pawn,
			'square': { 'column': 'b', 'row': 1, 'board': Global3D.BOARD_TYPE.BLACK_Q_ATTACK },
			'is_white': false
		},
		{
			'type': Global3D.PIECE_TYPE.knight,
			'square': { 'column': 'b', 'row': 2, 'board': Global3D.BOARD_TYPE.BLACK_Q_ATTACK },
			'is_white': false
		},
		{
			'type': Global3D.PIECE_TYPE.rook,
			'square': { 'column': 'a', 'row': 2, 'board': Global3D.BOARD_TYPE.BLACK_Q_ATTACK },
			'is_white': false
		},
	])
	
	for piece_data in initial_piece_state:
		var piece_instance = piece_prefab.instantiate()
		piece_instance.type = piece_data.type
		piece_instance.is_white = piece_data.is_white
		piece_instance.set_square(piece_data.square)
		piece_instance.update_position()
		Global3D.piece_list.push_front(piece_instance)
		add_child(piece_instance)
#
func _ready() -> void:
	CreateBoards()
	create_pieces()
	for b in Global3D.attack_board_instances:
		b.determin_owner()
	Global3D.game_over.connect(game_ending_logic)
	Global3D.game_state.is_white_turn = true

func _process(delta: float) -> void:
	var rayOrigin = Vector3()
	var rayEnd = Vector3()
	# ray casting
	if Input.is_action_just_pressed("click"):
		var space_state = get_world_3d().direct_space_state
		var mouse_position = get_viewport().get_mouse_position()
		rayOrigin = parent.get_node("Camera3D").project_ray_origin(mouse_position)
		rayEnd = rayOrigin + parent.get_node("Camera3D").project_ray_normal(mouse_position) * 1000
		var ray_query = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
		var intersection = space_state.intersect_ray(ray_query)
		# when there is an intersection
		
		
		if intersection:
			# something is wrong here if we do this to every object we click on
			# it is likely that we need to check if the item we intersected with
			# is infact a square and we can do that through grroups
			var square = intersection["collider"].get_parent().get_parent()
			
			print("in intersection")
			
			if Global3D.game_state.is_white_turn == Global3D.game_state.player_color:
				_process_piece_movement(square)
				
				_process_board_movement(square)
				
				if square.is_in_group("square"):
					square.print_notation()
					
					


func _process_board_movement(square):
	if (Input.is_key_pressed(KEY_CTRL) and Global3D.game_state['selected_attack_board'] == null):
		Global3D.game_state['selected_attack_board'] = get_attackBoard(square)
		# call update_commanding_pieces
	elif(Global3D.game_state['selected_attack_board'] != null):
		# determin exact move
		
		#check if board is ownd by player whoes turn it is here
		if(Global3D.game_state['selected_attack_board'].get_Color() == Global3D.game_state['is_white_turn']):
			print("Moving attackboard with id: ", Global3D.game_state['selected_attack_board'].id)
		else:
			print("Cannot move that board becasue the current player does not own it")
			Global3D.game_state['selected_attack_board'] = null
			return
		
		var move = {
			'column': square.notation['column'],
			'row': square.notation['row'],
			'board': square.notation['board'],
			'is_up': false
		}
		if (Input.is_key_pressed(KEY_SHIFT)):
			# player selects up
			move['is_up'] = true
		
		if(Global3D.game_state['selected_attack_board'].is_move_legal(move)):
			#move the attack board
			var new_dict = {
				'board': Global3D.game_state['selected_attack_board'].attack_board_dict['board'],
				'corner_square': {
					'column': move['column'],
					'row': move['row'],
					'board': move['board'],
				},
				'is_up': move['is_up']
			}

			parent.sendServerBoardMove(Global3D.game_state['selected_attack_board'].id, new_dict) 
			ab_move_to(Global3D.game_state['selected_attack_board'].id, new_dict)
			
			
		else :
			print("not a legal move")
			Global3D.game_state['selected_attack_board'] = null

func ab_move_to(id, new_dict):
	# instantiate copy board
			var b = attack_board_prefab.instantiate()
			# need to update global attack board instances
			Global3D.remove_board_by_id(id)
			b.id = id
			b.set_attack_board_dict(new_dict)
			add_child(b)
			
			Global3D.attack_board_instances.append(b)
			Global3D.game_state['selected_attack_board'] = null
			Global3D.change_turn()
			# need to update pieces on that board
			Global3D.update_pieces(new_dict['board'])
	

func get_attackBoard(square_IN: Node3D):
	var notation = square_IN.get_notation()
	var board_type = notation['board']
	if(Global3D.is_attack_board(board_type)):
			print("belongs to an attack board")
			# navigate parent to get refrence to the specific attackboard.gd
			var attackBoard = square_IN.get_parent()
			print("currently looking at: ", attackBoard)
			# update list of possible moves in attackBoard
			attackBoard.update_legal_moves()
			return attackBoard
	return null

func _process_piece_movement(square):
	var notation = square.get_notation()
	# If there is a piece selected
	if Global3D.game_state.selected_piece:
		var legal_moves = Global3D.game_state.selected_piece.legal_moves
		# If the selected piece can go to that square
		if is_legal(square.get_notation(), legal_moves):
			# this is where u move
			get_parent().sendServerMove(notation, Global3D.game_state.selected_piece.get_square())
			
			
			Global3D.game_state.selected_piece.move_to(notation)
	var piece = Global3D.check_square(notation)
	# select a piece if there is one
	if piece and Global3D.game_state.is_white_turn == piece.is_white:
		Global3D.game_state.selected_piece = piece
		piece.get_legal_moves()
		Global3D.hide_highlights()
		Global3D.highlight_squares(piece.legal_moves)
	else:
		Global3D.game_state.selected_piece = null
		Global3D.hide_highlights()

func is_legal(square, legal_moves):
	for m in legal_moves:
		if Global3D.compare_square_notations(m, square):
			return true
	return false

func game_ending_logic():
	print("Game over.")



#ethans server additions
var myTurn
var iAmWhitePieces
var inGame
#pass moves to server with
#get_parent().sendServerMove(square, pieceInfo)

#need a function to tear down and queue all the nodes built, the 2D version is call endGame()
func endGame():
	pass
	
#function to recieve move from the server: 
func receiveMoveFromServer(square,curr_square):
	#delete piece if on the piece
	var piece = Global3D.check_square(curr_square)
	piece.move_to(square)
	parent.get_node("GameControls/PanelContainer/VBoxContainer/MyTurnLabel").text = "It is your turn!"
	
	
	
func receiveBoardMoveFromServer(oldBoard,newBoard):
	#delete piece if on the piece
	#var piece = Global3D.check_square(curr_square)
	#piece.move_to(square)
	parent.get_node("GameControls/PanelContainer/VBoxContainer/MyTurnLabel").text = "It is your turn!"
	

	
func isMyTurn(x):
	Global3D.game_state.player_color = x #true for white, false for black
	print("my turn %s"%Global3D.game_state.player_color )
	
	if x:
		iAmWhitePieces = true
		#backRank = 1
		parent.get_node("GameControls/PanelContainer/VBoxContainer/MyPiecesLabel").text = "You are the white pieces" 
		parent.get_node("GameControls/PanelContainer/VBoxContainer/MyTurnLabel").text = "It is your turn!"
		
	else:
		iAmWhitePieces = false
		#backRank = 8
		parent.get_node("GameControls/PanelContainer/VBoxContainer/MyPiecesLabel").text = "You are the black pieces" 
		parent.get_node("GameControls/PanelContainer/VBoxContainer/MyTurnLabel").text = "not your turn yet.."
