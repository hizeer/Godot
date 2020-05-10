extends PopupMenu
func _ready():
	add_item ("puzzle",5)
	add_item ("Petit",8)
	add_item ("Moyen",10)
	add_item ("Grand",15)
	add_item ("Très grand",20)
func _on_Button5_pressed():
	popup()
