extends Node2D




func _on_retour_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scene/Menu.tscn")
	

func _ready():
	pass
