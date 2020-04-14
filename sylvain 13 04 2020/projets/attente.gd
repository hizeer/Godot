extends Control

var nextServrRq = OS.get_unix_time() + 20;
var serverCreated = false;
var pret = true;

func _ready():
	var isServer = infosGlobales.isServer;
	
	print(infosGlobales.serverPort)
	print(infosGlobales.hoteip)
	
	if(!isServer):
		print("connection au serveur")
		rejoindre_serveur()
		
		
func _process(delta):
	
	if(infosGlobales.isServer and ! serverCreated and pret and nextServrRq <= OS.get_unix_time()):
		pret = false
		print("envoi de la requette")
		var headers = ["type: launch","id: "+infosGlobales.selectedGame]
		get_node("/root/Control/HTTPRequest2").request("http://www.achline.fr:58080/",headers)




func _on_Button_pressed():
	var headers = ["type: quit","id: "+infosGlobales.selectedGame]
	$HTTPRequest.request("http://www.achline.fr:58080/",headers)



func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	get_tree().change_scene("res://creer.tscn")



func _on_HTTPRequest2_request_completed(result, response_code, headers, body):
	var res = body.get_string_from_utf8()
	print("reception de la requette")
	
	if(res != ""):
		infosGlobales.ips.clear()
		res = res.rsplit(" ", false)
		for i in res:
			infosGlobales.ips.push_back(i)
		print(infosGlobales.ips)
		serverCreated = true
		creer_serveur()
	else:
		print("partie pas prète")
		nextServrRq = OS.get_unix_time() + 20;
		pret = true









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


