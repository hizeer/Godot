extends Node

var info_serveur = {
	nom = "serveur", # Nom du serveur
	joueurs_max = 0, # Nombre de joeuurs max autorisé
	port_utilise = 0  # Port écouté
}

var players = {}

signal serveur_cree # Quand le serveur est créé
signal rejoint_succes # Quand le client a rejoint le serveur
signal rejoint_echec # Quand le client n'a pas rejoint le serveur
signal modification_liste_joueurs # Quand la liste des joueurs a changé

func _ready():
	get_tree().connect("network_peer_connected", self, "_joueur_connecte")
	get_tree().connect("network_peer_disconnected", self, "_joueur_deconnecte")
	get_tree().connect("connected_to_server", self, "_connexion_serveur_reussi")
	get_tree().connect("connection_failed", self, "_connexion_serveur_echoue")
	get_tree().connect("server_disconnected", self, "_deconnexion_serveur")
	set_meta("network",name)
	
# Tout le monde est averti de l'arrivée d'un nouveau client sur le serveur
func _joueur_connecte(_id):
		pass
	
# Tout le monde est averti quand quelqu'un est déconecté du serveur
func _joueur_deconnecte(id):
	players.erase(id)
	emit_signal("modification_liste_joueurs")
	
# Paire réussi à se connecter au serveur	
func _connexion_serveur_reussi():
	emit_signal("rejoint_succes")
	
	# Mise à jour les informations du joueur (id unique)
	gamestate.infos_joueur.net_id = get_tree().get_network_unique_id()
	
	# Demande au serveur d'enregistrer le nouveau joueur en le donnant aux autres joueurs
	rpc_id(1, "enregistrer_joueur",gamestate.infos_joueur)
	
	# S'enregistre lui-même dans sa liste
	enregistrer_joueur(gamestate.infos_joueur)
	
# Paire n'a pas réussi à se connecter au serveur
func _connexion_serveur_echoue():
	emit_signal("rejoint_echec")
	
# Paire notifiée quand déconnectée du serveur
func _deconnexion_serveur():
	pass 
	
func creer_server():
	# Initialisation du serveur
	var net = NetworkedMultiplayerENet.new()
	
	# Essai connexion au serveur
	if (net.create_server(info_serveur.port_utilise, info_serveur.joueurs_max)):
		print ("Impossible de créer le serveur")
		return
		
	# Assignement dans l'arbre
	get_tree().set_network_peer(net)
	
	# Envoi un signal indiquant serveur créé
	emit_signal("serveur_cree")
	
	# Enregistrer le serveur du joueur sur la liste des joueurs en local
	enregistrer_joueur(gamestate.infos_joueur)

func rejoindre_serveur(ip, port):
	var net = NetworkedMultiplayerENet.new()
	
	if (net.create_client(ip, port) != OK):
		print("Le client n'a pas été créé")
		emit_signal("rejoint_echec")
		return
	
	get_tree().set_network_peer(net)

remote func enregistrer_joueur(pinfo):
	if (get_tree().is_network_server()):
		# On est sur le serveur, donc on distribue la liste d'information des joueurs grâce aux joueurs connectés
		for id in players:
			# On envoie les infos des joueurs connectés au nouveau joueur
			rpc_id(pinfo.net_id,"enregistrer_joueur",players[id])
			# On envoie intérativement les infos du nouveau joueur aux joueurs connectés (sauf serveur, car pas de remote func sur le local)
			if(id != 1):
				rpc_id(id, "enregistrer_joueur",pinfo)
				
	print("Joueur enregistré ", pinfo.nom, " (", pinfo.net_id, ") à la liste des joueur")
	players[pinfo.net_id] = pinfo # Création d'une entrée dans le dico
	emit_signal("modification_liste_joueurs") # Notification de la modificationde la liste 	
