extends AcceptDialog



func _on_Button6_pressed():
	popup()


func _on_AcceptDialog_confirmed():
	var lab = get_node("../Panel/Label")
	var edit = get_node("TextEdit")
	lab.set_text(edit.get_text())
	get_node("../../Control").nomPartie = edit.get_text()

