extends Node

var server_infos = {
	name = "server", 
	max_players = 0,
	port = 0 
}

var players = {}

signal server_created 
signal join_success 
signal join_failed 
signal _on_players_list_modifs

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connection_server_success")
	get_tree().connect("connection_failed", self, "_connection_server_failed")
	get_tree().connect("server_disconnected", self, "_deconnection_server")
	connect("_on_players_list_modifs", self, "listejoueurmaj")
	
func _player_connected(id):
	pass
	
func _player_disconnected(id):
	players.erase(id)
	emit_signal("_on_players_list_modifs")
	
func _connection_server_success():
	emit_signal("join_success")
	
	gamestate.player_infos.net_id = get_tree().get_network_unique_id()
	
	# Ask the server to register the new player in each clients players list plus himself
	rpc_id(1, "register_players",gamestate.player_infos)
	
	# The new player registers himself in his players list
	register_players(gamestate.player_infos)
	
func _connection_server_failed():
	emit_signal("join_failed")
	
func _deconnection_server():
	pass 
	
func create_server():
	var net = NetworkedMultiplayerENet.new()
	
	if (net.create_server(server_infos.port, server_infos.max_players) != OK):
		print ("Impossible de créer le serveur")
		return
		
	# Tree assignement
	get_tree().set_network_peer(net)
	
	emit_signal("server_created")
	
	# Register server on his players list 
	register_players(gamestate.player_infos)

func join_server(ip, port):
	var net = NetworkedMultiplayerENet.new()
	
	if (net.create_client(ip, port) != OK):
		print("Le client n'a pas été créé")
		emit_signal("join_failed")
		return
	
	get_tree().set_network_peer(net)

remote func register_players(pinfo):
	if (get_tree().is_network_server()):
		
		# On the server, we share players information list thanks to connected players
		for id in players:
			# Send connected players infos to the new player  
			rpc_id(pinfo.net_id,"register_players",players[id])
		
			# Then send new players infos to connected players (except server, because of remote function)
			if(id != 1):
				rpc_id(id, "register_players",pinfo)
				
	print("Joueur enregistré ", pinfo.name, " (", pinfo.net_id, ") à la liste des joueurs")
	players[pinfo.net_id] = pinfo
	emit_signal("_on_players_list_modifs")
	
func listejoueurmaj():
	if infosGlobales.isServer and (players.size() == infosGlobales.infosPartie.maxPlayers):
		rpc("donner_data", infosGlobales.infosPartie["taillePlateau"], infosGlobales.infosPartie["ecartement"])
		rpc("lancer")
		
sync func lancer():
	get_tree().change_scene("res://scene/placement.tscn")
	

sync func donner_data(taille, ecart):
	GlobalLudo.largeur = taille
	GlobalLudo.longueur = taille
	GlobalLudo.density = ecart
	

