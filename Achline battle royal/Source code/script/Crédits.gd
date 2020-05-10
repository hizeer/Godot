extends Control


func _on_retour_menu_pressed():
	if GlobalLudo.bruitages:
		get_node("VBoxContainer/retour_menu/click").play()
	$fadeIn.show()
	$fadeIn.fade_in()



func _on_fadeIn_fade_finished():
	get_tree().change_scene("res://scene/Menu.tscn")
