extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_music_finished():
	get_node("ColorRect/VBoxContainer/VBoxContainer/Button").disabled = false


func _on_Button_pressed():
	#devenir spectateur
	GlobalLudo.ready = 5
	pass # Replace with function body.