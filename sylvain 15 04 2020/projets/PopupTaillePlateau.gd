extends PopupMenu


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(1,10):
		add_item (str(i*100),i*100)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_btTaillePlateau_pressed():
	popup()
