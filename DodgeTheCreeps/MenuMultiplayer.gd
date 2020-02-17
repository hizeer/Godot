extends CanvasLayer

func _ready():
	network.connect("serveur_cree",self, "_pret_a_jouer")
	network.connect("rejoint_succes",self,"_pret_a_jouer")
	network.connect("rejoint_echec",self,"_echec_rejoindre")


func _on_btCreer_pressed():
	# Récupérer les valeurs du GUI et les mettre dans le dico
	if(! $PanelHost/txtNomServeur.text.empty()):
		network.info_serveur.nom = $PanelHost/NomServeur.text
	network.info_serveur.joueurs_max = int($PanelHost/txtJoueursMax.value)
	network.info_serveur.port_utilise = int($PanelHost/txtPortServeur.text)
	
	# Créer le serveur 
	network.creer_server()

func _pret_a_jouer():
	get_tree().change_scene("res://Main.tscn")

func _echec_rejoindre():
	print("Echec connexion serveur")


func _on_btRejoindre_pressed():
	var port = int($PanelRejoindre/RejoindrePort.text)
	var ip = $PanelRejoindre/RejoindreIp.text
	network.rejoindre_serveur(ip, port)
