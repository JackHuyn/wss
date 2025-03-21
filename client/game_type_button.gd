extends CheckButton

signal setGameType(bool) 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	setGameType.emit(false) 
	print("signal emitted")
