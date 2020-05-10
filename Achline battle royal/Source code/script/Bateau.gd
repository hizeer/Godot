extends Node2D
var couleur = Color(1,1,1)
export(int) var _orientation = 0 # en degree la rotation du bateau par rapport "à la tête du bateau"
export(int) var _longueur = 3 # longueur du bateau en case
var _position  #_position est une case où se trouve la tête du bateau 
export(float) var _taille = 40.0 # taille des cases du bateau 
var moving = false #si le bateau doit être poser / déplacer
var alpha = false #pour savoir si on doit afficher le bateau en transparent
var plateau
var selectPos = 0 #position ou le bateau est selectionner 0 =debut(premier element)
var sousBatteaux = []
var user
var _vision = 7
var button
var last_position
var last_orientation
var rota = 0 # nombre de fois que le bateau à tourné
var hover = false
var options 
var tirRestant = 1
var mouvementRestant = 1
var portee = 5
var destroyed = false setget Destroy
var canMove = true
func SetPos(Vect):
	$Affichage.rect_position = Vect
	$Hover.rect_position = Vect
func Destroy(val):
	var returnval = true
	destroyed = val
	if destroyed and user == GlobalLudo.You:
		for bt in GlobalLudo.You.Boats:
			if !bt.destroyed:
				returnval = false
		if returnval:
			GlobalLudo.Game.rpc_id(1,"Lose", user.id)
func CreateSousBateau(name, texture): #Creer une node (texture_rect) lui donne un nom et une texture et la paramétre pour s'adapter aux container.
	var temp = TextureRect.new()
	temp.set_script(load("res://script/SousBateau.gd"))
	temp.set_name(name)
	temp.texture = load(texture)
	temp.expand = true
	temp.mouse_filter = Control.MOUSE_FILTER_IGNORE #Laisse passer les clics de souris mais les ignores
	temp.size_flags_horizontal = 3
	temp.size_flags_vertical = 3
	temp.belongto = self
	return temp
func invertRotation(orientation):
	if orientation <= 0:
		return orientation+180
	else:
		return orientation - 180
func posable(case):
	if !last_position:
		return case.Libre(_longueur-1-selectPos,_orientation) and case.Libre(selectPos, invertRotation(_orientation))
	else:
		return case.Libre2(_longueur-1-selectPos,_orientation) and case.Libre2(selectPos, invertRotation(_orientation))
func ReloadColor():
	if user:
		couleur = user.couleur
		$Affichage.modulate = couleur
		$Hover.modulate = couleur
	else:
		$Affichage.modulate = couleur
		$Hover.modulate = couleur
func Generate(longueur, taille): #Fonction qui créer la representation virtuel du bateau selon une longueur et une taille.
	if user:
		couleur = user.couleur
		modulate = couleur
	if longueur != _longueur:
		_longueur = longueur
	if taille != _taille:
		_taille = taille
	$Hover.rect_size = Vector2(taille, taille*longueur)
	$Hover.rect_pivot_offset = Vector2(taille/2, taille/2+taille*selectPos)

	$Affichage.rect_size= Vector2(taille, taille*longueur) #parametre la taille du conteneur pour être à la taille voulu
	$Affichage.rect_pivot_offset = Vector2(taille/2, taille/2+taille*selectPos) #position le centre de pivot au milieu de la case de la tête du navire

	var front = CreateSousBateau("Front","res://texture/Boat/BoatFront.png") #Creer un "sprite" / texture rectangle qui s'adapte au container / CreateSprite(nom de la node, adresse de la texture en String)
	$Affichage.add_child(front) #l'ajoute au container
	sousBatteaux.append(front)
	for _i in range(longueur-2): #genere le milieu du bateau par une boucle
		var middle
		var j = randi()%3+1 #nombre aleatoire entre 1 et 3 compris
		middle = CreateSousBateau("Middle%s" % j,"res://texture/Boat/Boat%s.png" % j) #choisis une texture entre Boat1, Boat2 et Boat3 
		get_node("Affichage").add_child(middle)
		sousBatteaux.append(middle)
	var back = CreateSousBateau("Back", "res://texture/Boat/BoatBack.png") #arriére du bateau
	get_node("Affichage").add_child(back)
	sousBatteaux.append(back)
func Recreate(longueur, taille, orientation): #fonction qui supprime tout les sprite et réutilise Generate pour recréer un bateau (inutiliser pour le moment)
	for child in get_node("Affichage").get_children():
		child.queue_free()
	Generate(longueur, taille)
	Rotate(orientation)
func Rotate(orientation): #fonction qui change l'orientation du bateau en degree
	if !moving:
		RemoveBoatFromPlateau()
		_position.PoserBateau(_longueur-1, orientation, self, _longueur-1)
	if orientation != _orientation:
		_orientation = orientation
	$Affichage.rect_rotation = orientation
	$Hover.rect_rotation = orientation
func HoverEnter():
	hover = true
	$Hover.visible = true
func HoverLeave():
	hover = false
	$Hover.visible = false
func regardBateau():
	for sb in sousBatteaux:
		sb.onCase.CaseVisible(_vision)
func RangeeBateau(val):
	for sb in sousBatteaux:
		sb.onCase.CasesPosables(val,portee)
func RemoveBoatFromPlateau():
	for sb in sousBatteaux:
		if sb.onCase:
			sb.onCase.bateau = null
			sb.onCase = null
sync func remoteMoveBoatWithOrientation(x,y, orientation): #must set plateau as global before
	moving = true
	Rotate(orientation)
	MoveBoatOnPlateau(GlobalLudo.Plateau.plateau[x][y])
sync func remoteMoveBoat(x,y): #must set plateau as global before
	MoveBoatOnPlateau(GlobalLudo.Plateau.plateau[x][y])
func MoveBoatOnPlateau(pos):
	RemoveBoatFromPlateau()
	_position = pos
	plateau = pos.plateau
	pos.PoserBateau(_longueur-1, _orientation, self, _longueur-1)
	setPivot(0)
	SetPos(pos.getPositionGlobal())
	setSize(pos.plateau.cellSize)
	SetLast()
	moving = false #le bateau ne se déplace plus
	GlobalLudo.You.moving = null
	selectPos = 0
func Revert():
	Rotate(last_orientation)
	MoveBoatOnPlateau(last_position)
func SetLast():
	last_position = _position
	last_orientation = _orientation
func setSize(size):
	if size != _taille:
		_taille = size
		$Affichage.rect_size= Vector2(size, size*_longueur) #parametre la taille du conteneur pour être à la taille voulu
		$Hover.rect_size = $Affichage.rect_size
		setPivot(0)
func setPivot(pivot):
	$Affichage.rect_pivot_offset = Vector2(_taille/2, _taille/2+_taille*pivot)
	$Hover.rect_pivot_offset = $Affichage.rect_pivot_offset
func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE) and GlobalLudo.You.destroying:
		GlobalLudo.You.destroying = false
	if Input.is_key_pressed(KEY_ESCAPE) and moving and last_position!= null:
		moving = false
		Revert()
	
	
	if event is InputEventMouseButton and moving and event.pressed: #Verifie si un "Bouton de la souris" est presser
		
		
		if event.button_index == BUTTON_WHEEL_UP: # Tourne le bateau dans le sens des aiguille d'une montre avec le scroll vers le haut
			var posActuel = plateau.Get_current(0,0)
			rota = 1
			if _orientation == 180:
				Rotate(-90)
			else:
				Rotate(_orientation+90)
			while !posable(posActuel) and rota <4: #si il ne peu pas se poser il se retourne et réessaye
				if _orientation == 180:
					Rotate(-90)
				else:
					Rotate(_orientation+90)
				rota+=1
				
				
		if event.button_index == BUTTON_WHEEL_DOWN: # tourne le bateau dans le sens inverse avec le scroll vers le bas 
			var posActuel = plateau.Get_current(0,0)
			rota = 1
			if _orientation == -90:
				Rotate(180)
			else:
				Rotate(_orientation-90)
			while !posable(posActuel) and rota <4: #si il ne peu pas se poser il se retourne et réessaye
				if _orientation == -90:
					Rotate(180)
				else:
					Rotate(_orientation-90)
				rota+=1


		if event.button_index == BUTTON_LEFT and GlobalLudo.Plateau.onPlateau: #Pose le bateau quand clique gauche sur le plateau à un endroit valide
			var position = plateau.Get_current(0,0) #stock la position pour eviter une difference graphic//grille
			if posable(position):
				var tete = position.get_case(selectPos, invertRotation(_orientation))
				if !last_position:
					GlobalLudo.You.Boats.append(self)
					MoveBoatOnPlateau(tete)
					GlobalLudo.ready -= 1
					
				else:
					GlobalLudo.Plateau.clearPosable()
					rpc("remoteMoveBoatWithOrientation", tete.x,tete.y, _orientation)
				if is_instance_valid(button): #si le bouton existe toujours
					button.activated = false #dépresse le bouton create
				#^ assure que le bateau se trouve bien a l'endroit précis
				
				plateau.RefreshFog()
				
				if last_position:
					mouvementRestant -= 1





	if event is InputEventMouseButton and !moving and event.pressed:
		if event.button_index == BUTTON_LEFT and hover and GlobalLudo.You._isTurn and user == GlobalLudo.You:
			options = load("res://scene/Boat_Action.tscn").instance()
			
			options.get_node("panneau/MoveButton").bateau = self
			options.get_node("panneau/FireButton").bateau = self
			options.get_node("panneau").rect_size =Vector2((_taille*3)/2,  (_taille*3)/4)   #taille du menu (ratio 1/2)
			options.get_node("panneau").rect_position = $Affichage.rect_position - options.get_node("panneau").rect_size+Vector2(_taille/2,_taille/2)
			add_child(options)
func _ready(): #genere un bateau dés que la fonction est appelle et le tourne dans la position voulu au spawn
# warning-ignore:return_value_discarded
	Generate(_longueur, _taille) 
	Rotate(_orientation)
# warning-ignore:unused_argument
func _process(delta): 
	if moving and posable(plateau.Get_current(0,0)): #Teste si le bateau est en déplacemement et si il peut se poser à l'endroit pointé
		SetPos(plateau.gridposition(0,-selectPos))
	#^ positionne le bateau sur une case par rapport au plateau.
	if moving != alpha: #affiche le bateau en transparent quand il se déplace sinon l'affiche normallement
		if moving:
			alpha = true
			modulate.a = 0.5 # modulate est la couleur appliqué à la node Color(r,g,b,a) quand blanc la node n'est pas altérer
		else:
			alpha = false
			modulate.a = 1
