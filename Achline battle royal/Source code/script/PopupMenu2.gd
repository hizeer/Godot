extends PopupMenu
func _ready():
	for i in range(1,13):
# warning-ignore:integer_division
		add_item (str(i*15 / 60)+"m "+str(i*15 % 60)+"s" ,i*15)


func _on_Button2_pressed():
	popup()
