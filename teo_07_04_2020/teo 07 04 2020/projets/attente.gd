extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	var isServer = infosGlobales.isServer;
	
	if(isServer):
		creer_serveur()
	else:
		rejoindre_serveur()

func _on_Button_pressed():
	var headers = ["type: quit"]
	$HTTPRequest.request("http://www.achline.fr:58080/",headers)

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	get_tree().change_scene("res://creer.tscn")

################## rejoindre_serveur
func rejoindre_serveur():
	network.connect("rejoint_echec",self,"_echec_rejoindre")
	# Maj données joueurs
	set_player_info()
	
	var port = infosGlobales.serverPort
	var ip = infosGlobales.hoteip
	network.rejoindre_serveur(ip, port)

func _echec_rejoindre():
	print("Echec connexion serveur")
	
func set_player_info():
	#if (!$PanelJoueur/txtNomJoueur.text.empty()):
	gamestate.infos_joueur.nom = infosGlobales.nomJoueur
	
################## creer_serveur

func creer_serveur():	
	# Maj données joueurs
	set_player_info()
	# Récupérer les valeurs du GUI et les mettre dans le dico
	#if(! $PanelHost/txtNomServeur.text.empty()):
	network.info_serveur.nom = infosGlobales.nomPartie
	network.info_serveur.joueurs_max = infosGlobales.infosPartie["maxPlayers"]
	network.info_serveur.port_utilise = infosGlobales.serverPort
	
	# Créer le serveur 
	network.creer_server()
