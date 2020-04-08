extends Control

var nbj
var bdsize


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_PopupMenu2_id_pressed(id):
	bdsize = id


func _on_PopupMenu_id_pressed(id):
	nbj = id


func _on_Button3_pressed():
	var headers = ["type: make","maxPlayers:"+str(nbj),"boardSize:"+str(bdsize)]
	infosGlobales.infosPartie["maxPlayers"] = nbj;
	infosGlobales.infosPartie["boardSize"] = bdsize;
	
	$HTTPRequest.request("http://www.achline.fr:58080/",headers)


func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
	infosGlobales.isServer = true
	get_tree().change_scene("res://attente.tscn")


func _on_Button4_pressed():
	get_tree().change_scene("res://menu.tscn")
