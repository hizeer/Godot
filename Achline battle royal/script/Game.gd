extends Node2D
var _plateau
var p1
var p2
var _joueurs = [] #on devra voir avec sylvain comment on ajoutera joueur
var _joueurActuel = null # passe une boucle dans joueur qui prend le joueur suivant non eliminer, c'est le joueur qui à finit son tour qui le calcul sinon premiere personne qu'il trouve qui est connecté
signal joueurChanged(JoueurAct)
var nbrTour = 0
var nbrJoueurs = 0
var maxShots = 5
var maxMoves = 5
var wait = 0
var functocall="Callall"
var numBoat = 0
var boatsReceived = 0

func EnvoyezBoat(boat):
	var P = {}
	P["id"] = GlobalLudo.You.id
	P["x"] = boat._position.x
	P["y"] = boat._position.y
	P["orientation"] = boat._orientation
	P["longueur"] = boat._longueur
	P["name"]= boat.name
	P["vision"]= boat._vision
	rpc("ReceiveBoat",P)


remote func ReceiveBoat(boat):
	var bt = load("res://scene/Batteau.tscn").instance()
	bt.SetPos(Vector2(-5000,-5000))
	bt.plateau= GlobalLudo.Plateau
	bt._position = GlobalLudo.Plateau.plateau[boat["x"]][boat["y"]]
	bt.last_position = bt._position
	bt._taille = GlobalLudo.Plateau.cellSize
	bt._longueur = boat["longueur"]
	bt._orientation = boat["orientation"]
	bt.name = boat["name"]
	bt._vision = boat["vision"]
	bt.user = IdToUser(boat["id"])
	bt.SetPos(bt._position.getPositionGlobal())
	IdToUser(boat["id"]).get_node("Batteaux").add_child(bt)
	IdToUser(boat["id"]).Boats.append(bt)
	rpc_id(boat["id"], "BoatReceived")

func IdToUser(id):
	for player in _joueurs:
		if player.id == id:
			return player


remote func BoatReceived():
	if boatsReceived+1 == nbrJoueurs-1:
		boatsReceived = 0
		numBoat+=1
		if numBoat == GlobalLudo.You.Boats.size():
			GlobalLudo.Game.rpc_id(1,"IncreaseWait")
		else:
			EnvoyezBoat(GlobalLudo.You.Boats[numBoat])
	else:
		boatsReceived+=1

sync func SendBoat():
	rpc("setVisible",true)
	p2 = preload("res://scene/Plateau.tscn").instance()
	p2.name = "P2"
	p2.rect_size = Vector2(500,500)
	p2.largeur = 40
	p2.longueur = 40
	p2.fog = true
	if GlobalLudo.You.Boats.size()>0:
		EnvoyezBoat(GlobalLudo.You.Boats[0])
	else:
		GlobalLudo.Game.rpc_id(1,"IncreaseWait")
	
	

var field_length = GlobalLudo.density * GlobalLudo.longueur + 6
var x
var y
var angle = (2*PI)
func SetPlateau():
	var max_x = GlobalLudo.largeur
	var max_y = GlobalLudo.longueur
	var min_x = 0
	var min_y = 0
	var max_size = 0
	angle = (2*PI) / nbrJoueurs
	
	min_x = field_length
	min_y = field_length
	
	
	#trouver la taille du plateau
	for i in nbrJoueurs:
		x = field_length * cos(i*angle) + GlobalLudo.largeur/2
		y = field_length * sin(i*angle) + GlobalLudo.longueur/2
		if max_x < x:
			max_x = x
		if max_y < y:
			max_y = y
		if min_x > x:
			min_x = x
		if min_y > y:
			min_y = y
	
	max_x = int(max_x - min_x + GlobalLudo.largeur + 4)
	max_y = int(max_y - min_y + GlobalLudo.longueur + 4)
	max_size = max(max_x, max_y)
	functocall = "SetBoats"
	rpc("setp2global",max_size+4, infosGlobales.infosPartie["dureeTour"])
	
var new_x
var new_y
var new_angle
func SetBoats():
	for player in _joueurs:
		x = int(p2.largeur/2 + (field_length * cos(player.ordre*angle) - GlobalLudo.largeur/2))
		y = int(p2.longueur/2 + (field_length * sin(player.ordre*angle) - GlobalLudo.longueur/2))
		for bat in player.Boats:
			if player.ordre*angle > 7*PI/4 or player.ordre*angle <= PI/4:
				new_x = bat._position.y + x
				new_y = GlobalLudo.longueur - bat._position.x + y
				new_angle = (bat._orientation + 270) % 360
			elif player.ordre*angle > 5*PI/4 and player.ordre*angle <= 7*PI/4:
				new_x = GlobalLudo.largeur - bat._position.x + x
				new_y = GlobalLudo.longueur- bat._position.y + y
				new_angle = (bat._orientation + 180) % 360
			elif player.ordre*angle > 3*PI/4 and player.ordre*angle <= 5*PI/4:
				new_x = GlobalLudo.largeur - bat._position.y + x
				new_y = bat._position.x + y
				new_angle = (bat._orientation + 90) % 360
			elif player.ordre*angle > PI/4 and player.ordre*angle <= 3*PI/4:
				new_x = bat._position.x + x
				new_y = bat._position.y + y
				new_angle = bat._orientation
			
			if new_angle >= 270:
				new_angle = new_angle - 360
			bat.rpc("remoteMoveBoatWithOrientation", new_x, new_y, new_angle)
	
	rpc("setVisible",false)
	rpc("SetJoueurActuel", _joueurs[int(rand_range(0,nbrJoueurs-1))].id)

sync func setVisible(val):
	$UI/Cache.visible = val
	if val == false:
		$UI/boats_placing.queue_free()
		#$UI/toGame.queue_free()
		$UI/toGame.hide()
		p1.queue_free()
		p2.RefreshFog()
		$"UI/Actual player".visible = true
		connect("joueurChanged", $"UI/Actual player", "ChangeNom")
		#$"UI/EndTurn".visible = true
		


sync func setp2global(size,duration):
	p2.largeur = size
	p2.longueur = size
	GlobalLudo.You.time = duration
	GlobalLudo.Plateau= p2
	p2.rect_size = Vector2(500,500)
	add_child(p2)
	move_child(p2, 0)
	p2.rect_position.x = get_viewport().size.x/2 - p2.rect_size.x/2
	p2.rect_position.y = get_viewport().size.y/2 - p2.rect_size.y/2
	rpc_id(1,"IncreaseWait")

func Callall():
	RandomizePlayers() #-----------------------
	AssociateColor() #-----------------------
	RandomizePlayers() #-----------------------
	functocall = "SetPlateau"
	
	rpc("SendBoat")



sync func IncreaseWait():
	if wait+1 == nbrJoueurs:
		wait = 0
		call(functocall)
	else:
		wait= wait + 1
sync func DecreaseWait():
	wait -=1



func AddOtherJoueur(name, id):
	var j = preload("res://scene/Joueur.tscn").instance()
	j.Name = name
	j.id = id
	get_node("Joueurs").add_child(j)
	_joueurs.append(j)
	nbrJoueurs += 1
	j.set_name(j.Name)
	if id == gamestate.player_infos.net_id:
		GlobalLudo.You = j
	
func RandomizePlayers():
	randomize()
	_joueurs.shuffle()
	for i in range(nbrJoueurs):
		_joueurs[i].rset("ordre",i)

sync func Lose(id):
	RemovePlayer(IdToUser(id))
	rpc_id(id,"Lost")
	if nbrJoueurs == 1:
		rpc_id(_joueurs[0].id, "Win")
	

sync func Lost():
	GlobalLudo.Plateau.fog= false
	get_node("UI/lose").add_child(lost)
	$UI/lose.show()
	$UI/ReturnToMenu.show()
	GlobalLudo.Plateau.RefreshFog()
	


sync func Win():
	GlobalLudo.Plateau.fog= false
	get_node("UI/win").add_child(win)
	$UI/win.show()
	


sync func RemovePlayer(j):
	nbrJoueurs -= 1
	if j != _joueurActuel:
		_joueurs.erase(j)
	else:
		if infosGlobales.isServer:
			rpc("SetJoueurActuel",JoueurSuivant(j.id).id)
		_joueurs.erase(j)

	
func JoueurSuivant(id): #seul l'hote devra l'utiliser
	var joueur = IdToUser(id)
	if joueur.ordre >= nbrJoueurs-1:
		if _joueurs[0].lost:
			JoueurSuivant(_joueurs[1].id)
		else:
			return _joueurs[0] 
	
	if _joueurs[joueur.ordre+1].lost:
		JoueurSuivant(_joueurs[joueur.ordre+1].id)
	else:
		return _joueurs[joueur.ordre+1]

sync func SetJoueurActuel(Id):
	if _joueurActuel:
		_joueurActuel._isTurn = false
	_joueurActuel = IdToUser(Id)
	if _joueurActuel == _joueurs[0]:
			nbrTour+= 1
	emit_signal("joueurChanged", _joueurActuel.Name)
	_joueurActuel._isTurn = true

func AssociateColor():
	for i in range(nbrJoueurs):
		_joueurs[i].rpc("SetCouleur",(Color.from_hsv(float(1+i)/nbrJoueurs,0.75,1,1)))

sync func FinTour():
	if infosGlobales.isServer:
		rpc("SetJoueurActuel",JoueurSuivant(_joueurActuel.id).id)
		
	else:
		rpc_id(1, "FinTour")


var option_toggle = false
var option_in_game = load("res://scene/option_in_game.tscn").instance()
var lost = load("res://scene/lose.tscn").instance()
var win = load("res://scene/victory.tscn").instance()


func _ready():
	GlobalLudo.Game = self
	for joueurs in network.players:
		AddOtherJoueur(network.players[joueurs].name,network.players[joueurs].net_id)
	
	p1 = preload("res://scene/Plateau.tscn").instance()
	p1.name = "P1"
	p1.rect_size = Vector2(500,500)
	p1.largeur = GlobalLudo.largeur
	p1.longueur = GlobalLudo.longueur
	GlobalLudo.Plateau = p1
	add_child(p1)
	p1.rect_position.x = get_viewport().size.x/2 - p1.rect_size.x/2
	p1.rect_position.y = get_viewport().size.y/2 - p1.rect_size.y/2
	move_child(p1, 0)
	
	get_node("UI/opt").add_child(option_in_game)
	option_in_game.hide()
	$UI/opt.hide()
	
	get_node("CanvasLayer")._modification_private_channel()


func _input(ev):
	if ev is InputEventKey and Input.is_action_pressed("ui_cancel") and not ev.echo:
		if GlobalLudo.You.moving:
			pass
		elif !option_toggle:
			$UI/opt.show()
			option_in_game.show()
			for c in get_node("UI/CanvasLayer").get_children():
				if c != get_node("UI/CanvasLayer/son_message"):
					c.hide()
		else:
			$UI/opt.hide()
			option_in_game.hide()
			get_node("UI/CanvasLayer/teteBox2").show()
		
		option_toggle = !option_toggle


func _process(delta):
	if GlobalLudo.ready <= 0:
		get_node("UI/toGame").disabled = false
	if GlobalLudo.musique:
		get_node("/root/Game/UI/music").stream_paused = false
	else:
		get_node("/root/Game/UI/music").stream_paused = true
	
	get_node("UI/music").volume_db = GlobalLudo.volume_musique


func _on_AudioStreamPlayer_finished():
	get_node("/root/Game/UI/music").play()
