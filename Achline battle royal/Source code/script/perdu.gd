extends Control
func _on_music_finished():
	get_node("ColorRect/VBoxContainer/VBoxContainer/Button").disabled = false
func _on_Button_pressed():
	#devenir spectateur
	get_parent().hide()
