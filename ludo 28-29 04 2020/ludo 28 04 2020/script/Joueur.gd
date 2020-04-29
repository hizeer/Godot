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
var time = -1


sync func Lose():
	lost = true


func setTurn(value):
	_isTurn = value
	
	if self == GlobalLudo.You:
		if value == true:
			debutTour()
		else:
			finTour()

func debutTour():
	$Timer.wait_time = time
	nbrShotsFired = 0
	nbrTimeMoved = 0
	#afficher le bouton Fintour
	#get_tree().get_root().
	get_node("/root/Game/UI/EndTurn").show()
	print(get_node("/root/Game/UI/EndTurn").visible)
	for bat in Boats:
		bat.tirRestant = 1
		bat.mouvementRestant = 1
	print("debut tour")
	$Timer.start()

func finTour():
	for bat in Boats:
		if is_instance_valid(bat.options):
			bat.options.get_node("panneau").freeOption() 
	if GlobalLudo.You.moving:
		GlobalLudo.You.moving.moving = null
		GlobalLudo.You.moving.Revert()
	if GlobalLudo.You.destroying:
		GlobalLudo.You.destroying = null
	$Timer.stop()
	#cacher le bouton Fintour
	get_node("/root/Game/UI/EndTurn").visible = false
	print(get_node("/root/Game/UI/EndTurn").visible)
	print("finTour")


func _ready():
	$Timer.connect("timeout", GlobalLudo.Game, "FinTour") #a changer pour une autre fonction qui provoque la fin du tour
	rset_config("ordre",MultiplayerAPI.RPC_MODE_REMOTESYNC)


sync func SetCouleur(color):
	if couleur != color:
		couleur = color
		for bat in Boats:
			bat.couleur = color
			bat.ReloadColor()




