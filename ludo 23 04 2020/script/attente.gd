extends Control

var nextServerReq = OS.get_unix_time() + 20
var serverCreated = false
var ready = true
var upnp = UPNP.new()

func _ready():
	var isServer = infosGlobales.isServer
	
	gamestate.name = infosGlobales.nomJoueur
	
	print("port : "+str(infosGlobales.serverPort))
	print(infosGlobales.hoteip)
	
	if(!isServer):
		get_node("btLancer").queue_free()
		print("connexion au serveur")
		join_server()
		
	if(isServer):
		upnp.discover()
		upnp.add_port_mapping(infosGlobales.serverPort)
		network.connect("ready_to_placement",self,"_on_ready_placement")
		create_server()
		
		var bouton_lancer = Button.new()
		bouton_lancer.set_position(Vector2(590.642,331.917))
		bouton_lancer.set_size(Vector2(189,63))
		bouton_lancer.set_text("LANCER")
		bouton_lancer.disabled = true
		bouton_lancer.connect("pressed", self, "_on_bouton_lancer_pressed")
		get_node(".").add_child(bouton_lancer)
		
#func _process(delta):	
		#pass

func _on_ready_placement():
	get_node("lbAttenteJoueurs").set_text("Prêt à jouer")
	get_node(".").get_child(5).disabled = false
	
func _on_bouton_lancer_pressed():
	rpc("lancer_jeu")
	
sync func lancer_jeu():
	get_tree().change_scene("res://scene/placement.tscn")
	
func _on_btRetour_pressed():
	var headers = ["type: quit","id: "+infosGlobales.selectedGame]
	$HTTPRequest.request("http://www.achline.fr:58080/",headers)

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	get_tree().set_network_peer(null)
	
	if(infosGlobales.isServer):
		upnp.delete_port_mapping(infosGlobales.serverPort)
		get_tree().change_scene("res://scene/creer.tscn")
	
	else:
		get_tree().change_scene("res://scene/rejoindre.tscn")

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
