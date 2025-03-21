extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global3D.move.connect(moved)
	Global3D.capture.connect(captured)
	Global3D.notify.connect(notify)
	Global3D.game_over.connect(game_end)

func moved():
	$move.play()

func captured():
	$capture.play()

func notify():
	$notify.play()

func game_end():
	$game_end.play()
