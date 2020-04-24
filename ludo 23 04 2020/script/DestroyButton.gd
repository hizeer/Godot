extends TextureRect
var hover = false setget SetHover
var activated = false setget SetActivated
export(Texture) var hoverTex = preload("res://Texture/Button/ButtonDestroyHover.png")
export(Texture) var activatedTex = preload("res://Texture/Button/ButtonDestroyPressed.png")
var normalTex = texture
var bateau
func SetActivated(act):
	activated = act
	GlobalLudo.You.destroying = bateau
	actualiserButton()
	
func SetHover(hov):
	hover = hov
	actualiserButton()

func actualiserButton():
	if GlobalLudo.You.destroying:
		texture = activatedTex
	else:
		if hover:
			texture = hoverTex
		else:
			texture = normalTex

func _ready():
# warning-ignore:return_value_discarded
	self.connect("mouse_entered", self, "SetHover", [true])#connect l'event de la souris qui rentre à une fonction
# warning-ignore:return_value_discarded
	self.connect("mouse_exited", self, "SetHover", [false]) #connect l'event de la souris qui sort à une fonction

func _input(event):
	if event is InputEventMouseButton:
		if hover and !GlobalLudo.You.moving and event.pressed and event.button_index == BUTTON_LEFT : #si on click gauche quand on est dessus 
			if !activated and bateau.tirRestant > 0 and bateau.user.nbrShotsFired < GlobalLudo.Game.maxShots:# si il n'est pas activé
				self.activated = true #signifie que le bouton est maintenant activé
				get_parent().get_parent().queue_free()
				GlobalLudo.Plateau.clearPosable()
