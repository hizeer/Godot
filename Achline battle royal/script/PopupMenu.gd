extends PopupMenu
func _ready():
	for i in range(2,21):
		add_item (str(i),i)

func _on_Button_pressed():
	popup()
