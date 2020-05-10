extends Camera2D
var dragging = false #si la caméra est en train de se déplacer
var was = Vector2(0,0) #ancienne position de la camera
var reference = Vector2(0,0) #position de la souris lors du click droit
var waszoom
export(Vector2) var _resolution = Vector2(1280,720)
var zoomMin = 1
func _ready():
# warning-ignore:return_value_discarded
	get_tree().get_root().connect("size_changed", self, "on_Window_Resize")


func on_Window_Resize():
	_resolution = get_viewport().size
	if _resolution.x > 0 and _resolution.y > 0: #si la fenetre est fermer, evite la division par 0 
		position = _resolution/2
		zoomMin = max(1280/ _resolution.x, 720 / _resolution.y) #Ajustement du zoom par rapport à la resolution optimal
		if zoom.x > zoomMin:
			zoom = Vector2(zoomMin,zoomMin)

func limit_Offset():
		offset.x = max(-GlobalLudo.Plateau.rect_size.x/2 ,	min(offset.x,GlobalLudo.Plateau.rect_size.x/2 )) # -width/2 + Margin left, Margin Left
		offset.y = max(-GlobalLudo.Plateau.rect_size.y/2 ,	min(offset.y,GlobalLudo.Plateau.rect_size.y/2 )) # -heigth/2 + Margin Top, Margin top
		#^Limite de position de la camera





func _input(event):
	on_Window_Resize()
	if event is InputEventMouseButton and event.is_pressed() and !GlobalLudo.You.moving: #Verifie si un "Bouton de la souris" est presser
		if event.button_index == BUTTON_WHEEL_UP : # zoom // plus la valeur zoom diminue plus ça zoom // valeur par defaut 1
			waszoom = zoom
			if zoom.x > 1.0 / GlobalLudo.Plateau.longueur: #limite de zoom par rapport à la taille du plateau
				zoom = Vector2(zoom.x*0.9 , zoom.y*0.9)
			else:
				if zoom.x < 1 / GlobalLudo.Plateau.longueur:
					zoom = Vector2(1 / GlobalLudo.Plateau.longueur,1 / GlobalLudo.Plateau.longueur)
			offset = offset + (-0.5*_resolution + event.position)*(waszoom - zoom)
			limit_Offset()
			was = offset
			reference = (event.position)

		if event.button_index == BUTTON_WHEEL_DOWN: # dezoom // plus la valeur de zoom est grand plus ça dezoom // valeur par default 1 
			waszoom =zoom
			if zoom.x*1.1 < zoomMin:#limite  de dezoom
				zoom = Vector2(zoom.x*1.1 , zoom.y*1.1)
			else:
				if zoom.x*1.1 > zoomMin:
					zoom = Vector2(zoomMin,zoomMin)
			offset = offset + (-position + event.position)*(waszoom - zoom)
			limit_Offset()
			was = offset
			reference = (event.position)
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT: #teste si click droit presser
		if !dragging and event.pressed: 
			was = offset #stocke l'ancienne position de la camera
			reference = (event.position) # stock la position du click par rapport au zoom
			dragging = true
		if dragging and !event.pressed:
			dragging = false
			
	if event is InputEventMouseMotion and dragging:
		offset = was - ((event.position) - (reference))*zoom#calcul la nouvelle position de la caméra
		limit_Offset()
