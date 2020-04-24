extends TextureRect
export(Texture) var hoverTex = preload("res://Texture/Button/ButtonBoatHover.png")
export(Texture) var activatedTex = preload("res://Texture/Button/ButtonBoatPressed.png")
var normalTex = texture
var hover = false  setget SetHover
var batteau #variable qui va stocker le bateau jusqu'a ce qu'il soit poser
var activated = false setget SetActivated
var destroyButton
export(int) var size = 4
export(int) var ordre = 0
export(int) var vision = 7
# voir DestroyButton.gd pour ce qui suit jusqu'a input

func SetActivated(act):
	activated = act
	actualiserButton()
	GlobalLudo.You.moving = act
	
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
				self.activated = true
				batteau = preload("res://scene/Batteau.tscn").instance() #instance bateau_affichage
				batteau.SetPos(Vector2(-5000,-5000))
				batteau.plateau= GlobalLudo.Plateau
				batteau._longueur = size #pour la longueur en case du bateau
				batteau.selectPos = ordre
				batteau._taille = GlobalLudo.Plateau.cellSize #lui donne la bonne taille
				batteau.user = GlobalLudo.You
				batteau.button = self
				batteau._vision = vision
				batteau.moving = true #définit que le bateau est en train d'être poser
				GlobalLudo.You.get_node("Batteaux").add_child(batteau) #le met enfant de plateau
			else:
				if batteau != null: # desactive le bouton / détruit le bateau en construction
					batteau.queue_free() #détruit les enfant
					batteau = null
					self.activated = false
