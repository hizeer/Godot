extends Control


func _on_music_victoere_finished():
	get_node("ColorRect/VBoxContainer/VBoxContainer/Button").disabled = false


func _on_Button_pressed():
	GlobalLudo.ready = 5
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scene/Menu.tscn")
