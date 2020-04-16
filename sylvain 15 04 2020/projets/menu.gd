extends Control

func _ready():
	pass
	
func _on_btRejoindre_pressed():
	get_tree().change_scene("res://rejoindre.tscn")

func _on_btCreer_pressed():
	get_tree().change_scene("res://creer.tscn")
