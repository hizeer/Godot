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
	var upnp = UPNP.new()
	var port
	upnp.discover(6000, 2, "InternetGatewayDevice")
	port = findPort(upnp,32500,65000)
	
	var headers = ["port: "+str(port),"type: make","maxPlayers:"+str(nbj),"boardSize:"+str(bdsize)]
	infosGlobales.serverPort = port;
	infosGlobales.infosPartie["maxPlayers"] = nbj;
	infosGlobales.infosPartie["boardSize"] = bdsize;
	
	$HTTPRequest.request("http://www.achline.fr:58080/",headers)


func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
	infosGlobales.isServer = true
	infosGlobales.selectedGame = body.get_string_from_utf8()
	print(body.get_string_from_utf8())
	get_tree().change_scene("res://attente.tscn")


func _on_Button4_pressed():
	get_tree().change_scene("res://menu.tscn")


func findPort(var upnp, var pas, var pmax):
	var i = pas
	while(i < pmax):
		if(upnp.add_port_mapping(i) == 0):
			return (i)
		i+=pas
	return(findPort(upnp, int(pas/2),pmax))

