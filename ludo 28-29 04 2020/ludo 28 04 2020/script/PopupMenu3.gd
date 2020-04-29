extends PopupMenu


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
		add_item ("Serré" , 1)
		add_item ("Normal", 2)
		add_item ("Ecarté", 3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button7_pressed():
	popup()
