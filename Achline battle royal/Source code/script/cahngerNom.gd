extends AcceptDialog




func _on_Button3_pressed():
	popup()


func _on_AcceptDialog_confirmed():
	var lab = get_node("../Label2")
	var edit = get_node("TextEdit")
	lab.set_text(edit.get_text())
	infosGlobales.nomJoueur = edit.get_text()
