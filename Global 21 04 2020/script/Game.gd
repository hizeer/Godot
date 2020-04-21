extends Node2D
var _plateau

var _joueurs = [] #on devra voir avec sylvain comment on ajoutera joueur
var _joueurActuel = null # passe une boucle dans joueur qui prend le joueur suivant non eliminer, c'est le joueur qui à finit son tour qui le calcul sinon premiere personne qu'il trouve qui est connecté
signal joueurChanged(JoueurAct)
var nbrTour = 0
var nbrJoueurs = 0
var maxShots = 5
var maxMoves = 5
func Addjoueur(joueur):
	joueur.ordre = nbrJoueurs
	get_node("Joueurs").add_child(joueur)
	_joueurs.append(joueur)
	nbrJoueurs += 1
	joueur.set_name(joueur.Name) 
	joueur.id = GlobalLudo.Id

remote func AddOtherJoueur(name, id):
	var j = preload("res://scene/Joueur.tscn").instance()
	j.Name = name
	j.id = id
	j.ordre = nbrJoueurs
	get_node("Joueurs").add_child(j)
	_joueurs.append(j)
	nbrJoueurs += 1
	j.set_name(j.Name) 	
	
func RandomizePlayers():
	randomize()
	_joueurs.shuffle()
	for i in range(nbrJoueurs):
		_joueurs[i].ordre = i

func RemovePlayer(j):
	if j != _joueurActuel:
		_joueurs.erase(j)
	else:
		SetJoueurActuel(JoueurSuivant(j))
		_joueurs.erase(j)
	nbrJoueurs -= 1
func JoueurSuivant(joueur):
	if joueur.ordre == nbrJoueurs-1:
		if _joueurs[0].lost:
			JoueurSuivant(_joueurs[1])
		else:
			return _joueurs[0] 
	
	if _joueurs[joueur.ordre+1].lost:
		JoueurSuivant(_joueurs[joueur.ordre+1])
	else:
		return _joueurs[joueur.ordre+1]

func SetJoueurActuel(joueur):
	if _joueurActuel:
		_joueurActuel._isTurn = false
	_joueurActuel = joueur
	emit_signal("joueurChanged", _joueurActuel.Name)
	joueur._isTurn = true
	print(joueur,"   ", joueur._isTurn)

func AssociateColor():
	for i in range(nbrJoueurs):
		_joueurs[i].SetCouleur(Color.from_hsv(float(1+i)/nbrJoueurs,0.75,1,1))

func FinTour():
	SetJoueurActuel(JoueurSuivant(_joueurActuel))
	if _joueurActuel == _joueurs[0]:
		nbrTour+= 1



var j1
var j2
var J
var p1
var p2
func _ready():
	GlobalLudo.Game = self
	#exemple en dessous
	#j2 = preload("res://scene/Joueur.tscn").instance()
	j1 = preload("res://scene/Joueur.tscn").instance()
	#j2.Name = "Kellian"
	GlobalLudo.You = j1
	
	#for i in range(7):
	#	J = preload("res://scene/Joueur.tscn").instance()
	#	J.Name = "J"+String(i)
	#	Addjoueur(J)
	#Addjoueur(j2)
	Addjoueur(j1)
	rpc("AddOtherJoueur",j1.Name, GlobalLudo.Id)
	

	
	p1 = preload("res://scene/Plateau.tscn").instance()
	p1.rect_size = Vector2(500,500)
	p1.largeur = GlobalLudo.largeur
	p1.longueur = GlobalLudo.longueur
	GlobalLudo.Plateau = self
	add_child(p1)
	p1.rect_position.x = get_viewport().size.x/2 - p1.rect_size.x/2
	p1.rect_position.y = get_viewport().size.y/2 - p1.rect_size.y/2
	move_child(p1, 0)


func _on_toGame_pressed():
	
	#envoie un mesage à l'hote lui dissant qu'il est près
	
	#activera le changement de plateau par la suite
	RandomizePlayers()
	AssociateColor()
	RandomizePlayers()
	SetJoueurActuel(j1)
	p2 = preload("res://scene/Plateau.tscn").instance()
	p2.rect_size = Vector2(500,500)
	p2.largeur = 40
	p2.longueur = 40
	p2.rect_size = Vector2(500,500)
	add_child(p2)
	move_child(p2, 0)
	p2.rect_position.x = get_viewport().size.x/2 - p1.rect_size.x/2
	p2.rect_position.y = get_viewport().size.y/2 - p1.rect_size.y/2
	$UI/boats_placing.queue_free()
	
	#déplacement des machins
	#exemple
	for bat in GlobalLudo.You.Boats:
		bat.MoveBoatOnPlateau(p2.plateau[bat._position.x][bat._position.y])
	#fin ddéplacement des machins destruction ancien plateau
	p1.queue_free()
	p2.RefreshFog()
	$"UI/Actual player".visible = true
	$"UI/End Turn".visible = true
	$"UI/Temps restant".visible = true
