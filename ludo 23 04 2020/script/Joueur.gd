extends Node
class_name Joueur


var _origin1 #Vector2 representera le carré de depart du joueur
var _origin2 #vector2
var _isTurn = false setget setTurn
var Boats = []
var nbrShotsFired = 0
var nbrTimeMoved = 0
var lost = false
var Name = "Not assigned"
var ordre = null
var couleur = Color(1,1,1)
var destroying = false
var moving = false
var spectating = true
var id = -1
func setTurn(value):
	_isTurn = value
	if value:
		debutTour()
	else:
		finTour()

func debutTour():
	nbrShotsFired = 0
	nbrTimeMoved = 0
	#afficher le bouton Fintour
	for bat in Boats:
		bat.tirRestant = 1
		bat.mouvementRestant = 1
	print("debut tour")
	if self == GlobalLudo.You:
		$Timer.start()

func finTour():
	if self == GlobalLudo.You:
		if GlobalLudo.You.moving:
			GlobalLudo.You.moving.moving = false
			GlobalLudo.You.moving.Revert()
		if GlobalLudo.You.destroying:
			GlobalLudo.You.destroying = false
	#cacher le bouton Fintour
	print("finTour")

func _ready():
	$Timer.connect("timeout", self, "finTour") #a changer pour une autre fonction qui provoque la fin du tour

func SetCouleur(color):
	if couleur != color:
		couleur = color
		for bat in Boats:
			bat.couleur = color
			bat.ReloadColor()
