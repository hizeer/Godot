extends Container
var x = 0 #lol c'est quoi le x de la case ?
var y = 0
var hover = false  #si la souris se trouve sur cette case
var hovercolor = Color(1, 0, 0, 1) #couleur du hover quand suprime / plus tard quand le hover du mouve sera implementer, lui aussi
var CaseH = null
var CaseB = null
var CaseG = null
var CaseD = null
var bateau = null 
var hit = false #si la case est endommager
var Taille = 10.0
var fog = true setget setFog
var posable = false setget Set_Posable

var plateau #reference au plateau qui sera faite dans son instanciation


func Set_Posable(val):
	posable = val
	if val:
		$Hitbox/ReferenceRect.modulate.a8 = 80
	else:
		$Hitbox/ReferenceRect.modulate.a8 = 0


func _ready():
# warning-ignore:return_value_discarded
	$Hitbox/ReferenceRect.connect("mouse_entered", self, "HoverEnter") #jargon habituel 
# warning-ignore:return_value_discarded
	$Hitbox/ReferenceRect.connect("mouse_exited", self, "HoverLeave") #dés que l'evenement "mouse_exited" se produit execute HoverLeave sur lui même
	$Hover/Contour.modulate = hovercolor #change la couleur de la node contour par hovercolor
	$"touched/Touché".rect_size = Vector2(Taille, Taille)
	$Hover/Contour.rect_size = Vector2(Taille, Taille)
	$Fog/fog.rect_size = Vector2(Taille, Taille)
	rect_size = Vector2(Taille, Taille)
	$Hitbox/ReferenceRect.rect_size = Vector2(Taille, Taille)

func HoverEnter():
	plateau.position = Vector2(x,y) #Donne au plateau la position actuelle
	hover = true
	plateau.onPlateau = true #define que l'on est sur le plateau
	if is_instance_valid(GlobalLudo.You.destroying) and !hit: #si on est en train de détruire une case affiche la case selectionner
		$Hover/Contour.visible = true
	if GlobalLudo.You._isTurn and !GlobalLudo.You.destroying and bateau:
		bateau.belongto.HoverEnter()
func HoverLeave():
	plateau.onPlateau = false #definie que l'on est plus sur le plateau
	hover = false
	$Hover/Contour.visible = false # masque le hover de la case une fois partie
	if GlobalLudo.You._isTurn and !GlobalLudo.You.destroying and bateau:
		bateau.belongto.HoverLeave()

func PoserBateau(longueur, orientation, boat, taille): #define les 'longueur' prochaine cases dans la direction 'orientation' comme des bateau, plus tard il les referencera comme case_bateau associer au bateau
	bateau = boat.sousBatteaux[taille-longueur];
	bateau.onCase = self
	if SuiteBateau(orientation) != null and longueur > 0: #continue de déclarer bateau tant que necessaire / possible
		SuiteBateau(orientation).PoserBateau(longueur-1, orientation, boat, taille)





func get_case(longueur, orientation):
	if longueur >0:
		print_debug(longueur)
		return SuiteBateau(orientation).get_case(longueur-1, orientation)
	else:
		return self

func Existe(taille, orientation): #fait comme libre sans verifie si il y a un obstacle
	if taille == 0:
		return true
	if SuiteBateau(orientation) != null:
		return SuiteBateau(orientation).Existe(taille-1, orientation)
	else:
		return false


func Libre(taille, orientation): #verifie si il n'y a pas d'obstacle et que les cases existes sur les 'taille' prochaine case dans la direction 'direction' 
	if hit or bateau:
		return false
	if taille == 0:
		return true
	if SuiteBateau(orientation) != null:
		return SuiteBateau(orientation).Libre(taille-1, orientation)
	else:
		return false

func Libre2(taille, orientation): #verifie si il n'y a pas d'obstacle et que les cases existes sur les 'taille' prochaine case dans la direction 'direction' 
	if hit or bateau or !posable:
		return false
	if taille == 0:
		return true
	if SuiteBateau(orientation) != null:
		return SuiteBateau(orientation).Libre2(taille-1, orientation)
	else:
		return false
func setFog(fg):
	fog = fg
	$Fog/fog.visible = fg


func getPositionGlobal():
	return Vector2(plateau.rect_position.x + plateau.cellSize * x, plateau.rect_position.y + plateau.cellSize * y)


func CaseVisible(distance):
	self.fog = false
	if distance > 0:
		if CaseH :
			CaseH.CaseVisible(distance-1)
		if CaseB :
			CaseB.CaseVisible(distance-1)
		if CaseD:
			CaseD.CaseVisible(distance-1)
		if CaseG:
			CaseG.CaseVisible(distance-1)

func CasesPosables(val,distance):
	self.posable = val
	if distance > 0:
		if CaseH and !CaseH.hit and !CaseH.bateau:
			CaseH.CasesPosables(val,distance-1)
		if CaseB and !CaseB.hit and !CaseB.bateau:
			CaseB.CasesPosables(val,distance-1)
		if CaseD and !CaseD.hit and !CaseD.bateau:
			CaseD.CasesPosables(val,distance-1)
		if CaseG and !CaseG.hit and !CaseG.bateau:
			CaseG.CasesPosables(val,distance-1)




func SuiteBateau(orientation): #obtiens la case à coté dans la direction donnée en degrée
	if orientation == 0 :
		return CaseB
	if orientation == 180 :
		return CaseH
	if orientation == -90 :
		return CaseD
	if orientation == 90 :
		return CaseG


sync func destroy():
	if bateau:
		bateau.damaged = true
		$"touched/Touché".texture = preload("res://texture/Case/touche.png") #texture = touché
		$"touched/Touché".visible = true #affiche  toucher
		hit = true #definie toucher
	else:
		$"touched/Touché".texture = preload("res://texture/Case/Rate.png")# texture = raté
		$"touched/Touché".visible = true #affiche  toucher
		hit = true #definie toucher

func _input(event):
	if event is InputEventMouseButton:
		if hover and is_instance_valid(GlobalLudo.You.destroying) and !hit and event.pressed and event.button_index == BUTTON_LEFT :
			if bateau: #si on clique sur une case quand on peu la detruire
				if bateau.belongto.user != GlobalLudo.You:
					rpc("destroy")
					HoverLeave() #quitte le hover
					GlobalLudo.You.destroying.tirRestant-=1
					GlobalLudo.You.destroying = null

			else:
				rpc("destroy")
				HoverLeave() #quitte le hover
				GlobalLudo.You.destroying.tirRestant-=1
				GlobalLudo.You.destroying = null
				
				
		if hover and !GlobalLudo.You.moving and (!bateau or bateau.belongto.user != GlobalLudo.You) and event.pressed and event.button_index == BUTTON_LEFT :
			GlobalLudo.Plateau.clearPosable()
			print("pute")
