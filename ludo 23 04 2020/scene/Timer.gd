extends Timer
func _ready():
	if get_parent() == GlobalLudo.You:
		GlobalLudo.Game.get_node()
