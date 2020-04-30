extends TextureRect
export(Texture) var hoverTex = preload("res://texture/Button/ButtonBoatHover.png")
export(Texture) var activatedTex = preload("res://texture/Button/ButtonBoatPressed.png")
var normalTex = texture
var hover = false  setget SetHover
var batteau #variable qui va stocker le bateau jusqu'a ce qu'il soit poser
var activated = false setget SetActivated
var destroyButton
export(int) var size = 4
export(int) var ordre = 0
export(int) var vision = 7
export(int) var portee = 5
export(int) var id
var placed
# voir DestroyButton.gd pour ce qui suit jusqu'a input

func SetActivated(act):
	activated = act
	actualiserButton()
	if !act:
		GlobalLudo.You.moving = null
		batteau = null

func SetHover(hov):
	hover = hov
	actualiserButton()

func actualiserButton():
	if activated:
		texture = activatedTex
	else:
		if hover:
			texture = hoverTex
		else:
			texture = normalTex


func _ready():
	self.connect("mouse_entered", self, "SetHover", [true])
	self.connect("mouse_exited", self, "SetHover", [false])
	


func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT and hover:
			if !activated and !GlobalLudo.You.moving:
				if GlobalLudo.ready > 0:
					self.activated = true
					batteau = load("res://scene/Batteau.tscn").instance() #instance bateau_affichage
					batteau.SetPos(Vector2(-5000,-5000))
					GlobalLudo.You.moving = batteau
					batteau.name = "Boat" + String(1+GlobalLudo.You.Boats.size())+" de "+GlobalLudo.You.Name
					batteau.plateau= GlobalLudo.Plateau
					batteau._longueur = size #pour la longueur en case du bateau
					batteau.selectPos = ordre
					batteau._taille = GlobalLudo.Plateau.cellSize #lui donne la bonne taille
					batteau.user = GlobalLudo.You
					batteau.button = self
					batteau._vision = vision
					batteau.portee = portee
					batteau.moving = true #définit que le bateau est en train d'être poser
					GlobalLudo.You.get_node("Batteaux").add_child(batteau) #le met enfant de plateau
			else:
				if batteau != null: # desactive le bouton / détruit le bateau en construction
					batteau.queue_free() #détruit les enfant
					GlobalLudo.You.moving = null
					batteau = null
					self.activated = false
