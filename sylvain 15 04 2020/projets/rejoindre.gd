extends Control


func _ready():
	var headers = ["type: aff"]
	$HTTPRequest.request("http://www.achline.fr:58080/",headers)


func _on_Button_pressed():
	get_tree().change_scene("res://menu.tscn")



func _on_AcceptDialog_confirmed():
	get_tree().change_scene("res://rejoindre.tscn")