extends TextureRect
export(Texture) var hoverTex = preload("res://Texture/Button/ButtonBoatHover.png")
export(Texture) var activatedTex = preload("res://Texture/Button/ButtonBoatPressed.png")
var normalTex = texture
var hover = false  setget SetHover
var bateau #variable qui va stocker le bateau à déplacer
var activated = false setget SetActivated
# voir DestroyButton.gd pour ce qui suit jusqu'a input

func SetActivated(act):
	activated = act
	actualiserButton()
	GlobalLudo.You.moving = bateau
	
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
# warning-ignore:return_value_discarded
	self.connect("mouse_entered", self, "SetHover", [true])
# warning-ignore:return_value_discarded
	self.connect("mouse_exited", self, "SetHover", [false])

func _input(event):
	if event is InputEventMouseButton:
		if hover and !GlobalLudo.You.destroying and event.pressed and event.button_index == BUTTON_LEFT :
			if !activated and !GlobalLudo.You.moving and bateau.mouvementRestant >0 and bateau.user.nbrTimeMoved < GlobalLudo.Game.maxMoves:
				self.activated = true
				bateau.button = self
				bateau.RemoveBoatFromPlateau()
				bateau.moving = true #définit que le bateau est en train d'être déplacer
				get_parent().get_parent().queue_free()
