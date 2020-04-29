extends Control

var scene

func _ready():
	var headers = ["type: aff"]
	$HTTPRequest.request("http://www.achline.fr:58080/",headers)


func _on_AcceptDialog_confirmed():
	get_tree().change_scene("res://scene/rejoindre.tscn")


func _on_btRetour_pressed():
	if GlobalLudo.bruitages:
		get_node("clic").play()
	$fadeIn.show()
	$fadeIn.fade_in()
	scene = "res://scene/menuSylv.tscn"


func _on_fadeIn_fade_finished():
	get_tree().change_scene(scene)
