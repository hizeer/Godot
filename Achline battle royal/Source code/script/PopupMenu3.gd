extends PopupMenu
func _ready():
		add_item ("Serré" , 1)
		add_item ("Normal", 2)
		add_item ("Ecarté", 3)


func _on_Button7_pressed():
	popup()
