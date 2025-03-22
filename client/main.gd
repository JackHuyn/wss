extends Node3D

@export var game_scene: PackedScene


const SCENE2D = preload("res://2D_chess/2D_chess.tscn")
const SCENE3D = preload("res://3D_chess/3D_chess.tscn")

var client
var clientCert = X509Certificate.new()
var ip
const PORT = 9010

#Game Data
var code 
var myID 
var oppId 
var oppName
var myTurn

var theUsername


var squareImOn
var squareClicked
var pieceOnSquare

var homepage 
var inGame

var gameControls
var codeLabel
var oppLabel
var myPiecesLabel
var leaveButton


var wantsToWatch

var currentlySelectedPiece
var selectedPieceOrigColour

var inCheck
var myKingsPos
var kingRookPieceInfo
var queenRookPieceInfo
var checkmate
var firstMoveMade
var backRank

var gameTime

var gameType
var curSceneInstance
var childScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	checkmate = false
	inCheck = false
	myID = 0
	code = 0
	oppId = 0
	# make a new function to handle server connection
	joinServer()
	inGame = false
	wantsToWatch = false
	
	homePage()
	
	var gameTypeButton = $Homepage/GameTypeButton
	gameTypeButton.connect("setGameType", _on_game_type_button_toggled.bind())

	
	GameControlsVisible(false)
	$GameControls/GameCommunication.visible = false
	loadingScreenVisible(false)
	
	
func _process(delta):
	client.poll()

func joinServer():
	print("Connecting To Server ...")	
	client = WebSocketMultiplayerPeer.new()
	ip = "wss://127.0.0.1:9010"
	#ip = "wss://3.82.68.55:9010"
	clientCert = load("res://Certificate/client_Cert.crt")
	var tls_opt = TLSOptions.client_unsafe(clientCert)
	#client.create_client(ip)	
	client.create_client(ip, tls_opt)	
	multiplayer.multiplayer_peer = client
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	


func joinTheGame(gameCode):
	wantsToWatch = false
	joinGame.rpc(myID, gameCode, theUsername, wantsToWatch)	
	code = int(gameCode)
	


func newGame(): 	
	print("NEW GAME")
	rpc_id(1, "createNewGame", myID, theUsername, gameTime, gameType)



@rpc("any_peer")
func getCode(gameCode):
	code = gameCode
	print(code)
	$GameControls/PanelContainer/VBoxContainer/CodeLabel.text = "Code: %s" %code 
	$LoadingScreen/PanelContainer/VBoxContainer/Label.text = "Code: %s" %code
	
@rpc("any_peer")
func loadingScreen():
	loadingScreenVisible(true)
	

func homePage():
	homepage = $Homepage
	homepage.connect("joinGame", joinTheGame.bind())
	homepage.connect("newGame", newGame.bind())
	homepage.connect("theUsername", theUsernamePasser.bind())
	homepage.connect("time", setGameTime.bind())

@rpc
func startGame(gameTypeFromServer):
	print("in start game")
	if gameTypeFromServer == "2D": 
		#start 2D game
		# when deciding the game type		
		game_scene = SCENE2D
		
	else : 
		#start 3D game
		game_scene = SCENE3D
	
	print(game_scene)
	curSceneInstance = game_scene.instantiate()
	add_child(curSceneInstance)
	print(curSceneInstance)

	print("game started from server call")	
	loadingScreenVisible(false)
	$Start.play()
	
	inGame = true
	firstMoveMade = false
	
		#$Camera3D.position.z = -7.564
		#$Camera3D.rotate_y(deg_to_rad(180))
	$GameControls/PanelContainer/VBoxContainer/HBoxContainer/MyNameLabel.text = theUsername
	GameControlsVisible(true)
	$myTimer.start()
	$oppsTimer.start()
	flipTimers()



func checkMate():
	print("checkmate")
	inGame = false
	$myTimer.stop()
	$oppsTimer.stop()	
	$EndGameDisplay/PanelContainer/VBoxContainer/Label.text = "You have been Checkmated"	
	endGameDisplayVisible(true)
	rpc_id(1, "sendOppTheyWon", myID, code)
	
	#Send signal to server saying you won! 
	
@rpc("any_peer") #when server runs this it makes the opponents move appear on your screen
func sendOppTheyWon():	
	$EndGameDisplay/PanelContainer/VBoxContainer/Label.text = "You have Checkmated your Opponent"
	endGameDisplayVisible(true)



@rpc("any_peer") #when server runs this it makes the opponents move appear on your screen
func sendOppMove(square, pieceInfo):	
	curSceneInstance.receiveMoveFromServer(square,pieceInfo)


@rpc("any_peer")
func sendOppBoardMove(id, newBoard):
	print("recieved move")
	curSceneInstance.ab_move_to(id, newBoard)
	

@rpc("any_peer") #when connected to an opponent tell them the opps id
func connectToOpp(opponentId, oppsName):
	oppId = opponentId
	oppName = oppsName
	$GameControls/PanelContainer/VBoxContainer/HBoxContainer/OpponentLabel.text = "%s" %oppName
	print("Currently playing against: " + str(oppId))


@rpc
func sync_player_list(updated_connected_peer_ids):
	print("Currently connected Players: " + str(updated_connected_peer_ids))
	
	
@rpc
func isMyTurn(x):	
	print("in is my turn game")
	curSceneInstance.isMyTurn(x)
	
		
		

	

func endGame(): 
	
	#if curSceneInstance:
		#curSceneInstance.endGame()
		
	remove_child(curSceneInstance)
	
	inGame = false
	print("about to end game")

	oppId = 0
	code = 0
	$Homepage/CodeTextBox.text = ""
	
	$myTimer.stop()
	$oppsTimer.stop()
	
	homepage._ready()	
	
@rpc("any_peer")
func oppDisconnected():
	#trigger end of game and error message
	$myTimer.stop()
	$oppsTimer.stop()
	$GameControls/PanelContainer/VBoxContainer/LeaveButton.visible = false
	
	print("opp disconnected")
	$EndGameDisplay/PanelContainer/VBoxContainer/Label.text = "Your Opponent Has Been Disconnected"	
	endGameDisplayVisible(true)



@rpc("any_peer")
func invalidJoinGame(isAGame):
	if isAGame: 
		$Homepage/InvalidJoinGame.text = "Game is full"
	else:
		$Homepage/InvalidJoinGame.text = "There is no game with that code, please verify you have the right code or start new game"
	
	$Homepage/Subtitle.visible = false
	$Homepage/InvalidJoinGame.visible = true
	$Homepage/CodeTextBox.visible = true
	$Homepage/EnterCode.visible = true
	$Homepage/Play.visible = true	
	$Homepage/Back.visible = true
	$Homepage/Title.visible = true
	


func theUsernamePasser(theName):
	#print("passing username into func")
	theUsername = theName
	$GameControls/PanelContainer/VBoxContainer/HBoxContainer/MyNameLabel.text = theUsername
	$LoadingScreen/PanelContainer/VBoxContainer/SubLabel.text = "Welcome %s" %theUsername
	
	
func _on_connected_to_server():
	myID = multiplayer.get_unique_id()
	print("Connected! UID is ", myID)

func _on_server_disconnected():
	client.close()
	inGame = false
	print("Connection to server lost.")

func _on_leave_button_pressed() -> void:
	#need to verify that opponent hasn't just left the game
	#if we both leave at the same time the server breaks
	$myTimer.stop()
	$oppsTimer.stop()
	loadingScreenVisible(false)
	rpc_id(1, "leftGame", myID, code)
	endGame()


func _on_disconnected_button_pressed() -> void:
	endGame()
	endGameDisplayVisible(false)


	
@rpc("any_peer")
func serverIsLegal(_oppID, _square, _piece):
	pass
	
@rpc("any_peer")
func serverBoardMoveIsLegal(_oppID, _oldBoard, _newBoard):
	pass
	
@rpc("any_peer")
func leftGame(_myID, _code):
	pass
	
@rpc("any_peer")
func createNewGame(_userID):
	pass	

@rpc("any_peer")
func joinGame(_id, _code, _name, _wannaWatch):
	pass
	


func GameControlsVisible(isOn): 
	$GameControls.visible = isOn
	$GameControls/PanelContainer.visible = isOn
	$GameControls/PanelContainer/VBoxContainer.visible = isOn
	$GameControls/PanelContainer/VBoxContainer/CodeLabel.visible = isOn
	$GameControls/PanelContainer/VBoxContainer/HBoxContainer.visible = isOn
	$GameControls/PanelContainer/VBoxContainer/HBoxContainer/MyNameLabel.visible = isOn
	$GameControls/PanelContainer/VBoxContainer/HBoxContainer/OpponentLabel.visible = isOn
	$GameControls/PanelContainer/VBoxContainer/LeaveButton.visible = isOn
	$GameControls/PanelContainer/VBoxContainer/MyPiecesLabel.visible = isOn
	$GameControls/PanelContainer/VBoxContainer/MyTurnLabel.visible = isOn
	#$GameControls/GameCommunication.visible = isOn
			
		
func loadingScreenVisible(isOn):
	$LoadingScreen.visible = isOn
	$LoadingScreen/PanelContainer.visible = isOn
	$LoadingScreen/PanelContainer/VBoxContainer.visible = isOn
	$LoadingScreen/PanelContainer/VBoxContainer/Label.visible = isOn
	$LoadingScreen/PanelContainer/VBoxContainer/SubLabel.visible = isOn
	$LoadingScreen/PanelContainer/VBoxContainer/SubLabel2.visible = isOn
	$LoadingScreen/PanelContainer/VBoxContainer/SubLabel3.visible = isOn
	$LoadingScreen/PanelContainer/VBoxContainer/TextureRect.visible = isOn
	$LoadingScreen.isOn(isOn)
	

func endGameDisplayVisible(isOn):
	$EndGameDisplay.visible = isOn
	$EndGameDisplay/PanelContainer.visible = isOn
	$EndGameDisplay/PanelContainer/VBoxContainer.visible = isOn
	$EndGameDisplay/PanelContainer/VBoxContainer/DisconnectedButton.visible = isOn
	$EndGameDisplay/PanelContainer/VBoxContainer/Label.visible = isOn

	


func _on_send_button_pressed() -> void:
	var curText = $GameControls/PanelContainer/VBoxContainer/HBoxContainer2/LineEdit.text
	
	if curText.length() > 1:						
		var sendingText = str("[left] ",theUsername,": ", curText, "\n[/left]")
		$GameControls/PanelContainer/VBoxContainer/HBoxContainer2/LineEdit.text = ""	
		$GameControls/PanelContainer/VBoxContainer/RichTextLabel.text += sendingText
		rpc_id(1, "sendText", sendingText, myID, code)
		$GameControls/PanelContainer/ChatLabel.visible = false



@rpc("any_peer")
func sendText(_text, _myID, _code):
	pass
	
@rpc("any_peer")
func receiveText(text):
	$GameControls/PanelContainer/VBoxContainer/RichTextLabel.text += text
	$GameControls/PanelContainer/ChatLabel.visible = false
	
	
	
	


func setGameTime(selectedTime): 
	gameTime = selectedTime


func _on_my_timer_timeout() -> void:
	$EndGameDisplay/PanelContainer/VBoxContainer/Label.text = "You have ran out of time"	
	endGameDisplayVisible(true)


func _on_opps_timer_timeout() -> void:
	$EndGameDisplay/PanelContainer/VBoxContainer/Label.text = "Your opponent has run out of time"	
	endGameDisplayVisible(true)
	
	
@rpc("any_peer")
func recieveTime(time):
	print("in receive time")
	gameTime = time
	$myTimer.setGameTime(gameTime)
	$oppsTimer.setGameTime(gameTime)
	
func flipTimers(): 
	if myTurn:
		$oppsTimer.set_paused(true)
		$oppsTimer.setMyTurn(false)
		
		$myTimer.setMyTurn(true)
		$myTimer.set_paused(false)
		


	else:
		$myTimer.set_paused(true)
		$myTimer.setMyTurn(false)
		
		$oppsTimer.setMyTurn(true)
		$oppsTimer.set_paused(false)
	


func _on_game_type_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		gameType = "3D"
	else: 
		gameType = "2D"	
	$Homepage/GameTypeButton.text = gameType
	print("the game type is %s"%gameType)
	
func _on_game_type_button_set_game_type(bool) -> void:
	_on_game_type_button_toggled(false)


func sendServerMove(square, pieceInfo): 
	serverIsLegal.rpc(oppId,square, pieceInfo)
	$GameControls/PanelContainer/VBoxContainer/MyTurnLabel.text = "it is not your turn.."
		
func sendServerBoardMove(id, newBoard):	
	serverBoardMoveIsLegal.rpc(oppId, id, newBoard)
	$GameControls/PanelContainer/VBoxContainer/MyTurnLabel.text = "it is not your turn.."
	
	
