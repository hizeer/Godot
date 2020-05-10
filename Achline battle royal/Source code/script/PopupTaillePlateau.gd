extends PopupMenu
func _ready():
	for i in range(1,10):
		add_item (str(i*100),i*100)

func _on_btTaillePlateau_pressed():
	popup()
