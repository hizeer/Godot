extends PopupMenu


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_item ("puzzle",5)
	add_item ("Petit",8)
	add_item ("Moyen",10)
	add_item ("Grand",15)
	add_item ("Très grand",20)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button5_pressed():
	popup()
