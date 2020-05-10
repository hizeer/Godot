extends Control

var nextServerReq = OS.get_unix_time() + 20
var serverCreated = false
var ready = true
var upnp = UPNP.new()


func _ready():
	var isServer = infosGlobales.isServer
	
	gamestate.name = infosGlobales.nomJoueur
	
	if(!isServer):
		print("connexion au serveur")
		join_server()
		
	if(isServer):
		
		upnp.discover()
		upnp.add_port_mapping(infosGlobales.serverPort)
		create_server();
	
	
#func _process(delta):	
#	if(network.players.size() == InfosGlobales.infos_serveur.joueurs_max):
	# get_tree().change_scence("res://*.tscn")

func _on_btRetour_pressed():
	var headers = ["type: quit","id: "+infosGlobales.selectedGame]
	$HTTPRequest.request("http://www.achline.fr:58080/",headers)

# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	get_tree().set_network_peer(null)
	
	if(infosGlobales.isServer):
		upnp.delete_port_mapping(infosGlobales.serverPort)
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scene/creer.tscn")
	
	else:
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scene/rejoindre.tscn")

# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_HTTPRequest2_request_completed(result, response_code, headers, body):
	var res = body.get_string_from_utf8()
	print("réception de la requête")
	
	if(res != ""):
		infosGlobales.ips.clear()
		res = res.rsplit(" ", false)
		for i in res:
			infosGlobales.ips.push_back(i)
		print(infosGlobales.ips)
		serverCreated = true
		create_server()
		
	else:
		print("partie pas prête")
		nextServerReq = OS.get_unix_time() + 20;
		ready = true


################## rejoindre_serveur
func join_server():
# warning-ignore:return_value_discarded
	network.connect("join_failed",self,"_join_failed")
	
	# Maj données joueurs
	set_player_infos()
	
	var port = infosGlobales.serverPort
	var ip = infosGlobales.hoteip
	network.join_server(ip, port)

func _join_failed():
	print("Echec connexion serveur")
	
func set_player_infos():
	gamestate.player_infos.name = infosGlobales.nomJoueur
	
################## creer_serveur
func create_server():	

	set_player_infos()

	network.server_infos.name = infosGlobales.nomPartie
	network.server_infos.max_players = infosGlobales.infosPartie["maxPlayers"]
	network.server_infos.port = infosGlobales.serverPort
	
	network.create_server()

