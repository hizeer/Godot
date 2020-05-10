extends Button

func _on_ReturnToMenu_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scene/Menu.tscn")
