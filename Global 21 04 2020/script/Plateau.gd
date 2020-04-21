extends Panel
var plateau = []
export(float) var longueur = 20.0 #longeur en case
export(float) var largeur = 20.0 #largeur en case
var cellSize = 0.0 #taille des cases
var onPlateau = false #variable qui signifie si la souris se trouve sur le plateau
var position = Vector2(0,0) #position actuelle /dernier sur le plateau
var Game
var Bateaux = []



func on_Window_Resize():
	rect_position = get_viewport().size/2 - rect_size/2
	for joueur in GlobalLudo.Game._joueurs:
		for bat in joueur.Boats:
			bat.SetPos(bat.sousBatteaux[0].onCase.getPositionGlobal()) # a régler
			if is_instance_valid(bat.options) and bat.options:
				bat.options.get_node("panneau").rect_position = bat.get_node('Affichage').rect_position - bat.options.get_node("panneau").rect_size+Vector2(bat._taille/2,bat._taille/2)


func Get_current(plusX,plusY):
	return plateau[position.x+plusX][position.y+plusY] #renvoie la case se trouvent à la position actuelle /derniere + des des coordonnée en plus
	#Get_current(1,0) rend la case au dessus de la case actuelle
		
func gridposition(plusX, plusY): #donne la position absolue d'oû se trouve la case actuelle
	return Vector2(rect_position.x + cellSize * (position.x + plusX), rect_position.y + cellSize * (position.y + plusY))
	
func RefreshFog():
	for ligne in plateau:
		for case in ligne:
			case.setFog(true)
	for bt in GlobalLudo.You.Boats:
		bt.regardBateau()


var temp

func _ready():
	self.material.set_shader_param("taille",longueur)
	get_tree().get_root().connect("size_changed", self, "on_Window_Resize")
	on_Window_Resize()
	Game = get_parent()
	cellSize = float(rect_size.x /longueur)
	GlobalLudo.Plateau = self #signifie à la variable global qu'il est le plateau
	#columns = largeur # définit le nombre de colones du container par rapport à la largeur
	for i in range(longueur):# remplie le tableau
		plateau.append([])#ajoute une liste vide à la liste pour créer un tableau
		for j in range(largeur):
			plateau[i].append(preload("res://scene/Case.tscn").instance()) #instanse une case
			plateau[i][j].Taille = float(cellSize)
			#attribue à chaque case ça case haute / base / droite / gauche
			if(j>0):
				plateau[i][j].CaseH = plateau[i][j-1] 
				plateau[i][j-1].CaseB = plateau[i][j]
			if(i>0):
				plateau[i][j].CaseG = plateau[i-1][j]
				plateau[i-1][j].CaseD = plateau[i][j]
			plateau[i][j].x = i # donne la position x 
			plateau[i][j].y = j # donne la position y
			plateau[i][j].plateau = self # signifie au cases qu'il est le plateau
			plateau[i][j].rect_size =Vector2(cellSize,cellSize)
			plateau[i][j].rect_position = Vector2(i*cellSize,j*cellSize)
			add_child(plateau[i][j]) #les ajoutes au container


