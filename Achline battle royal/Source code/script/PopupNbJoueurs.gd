extends PopupMenu
func _ready():
	for i in range(2,10):
		add_item (str(i),i)
func _on_btNbJoueurs_pressed():
	popup()
