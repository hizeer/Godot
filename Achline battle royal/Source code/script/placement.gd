extends Control

var p1
var j1

# Called when the node enters the scene tree for the first time.
func _ready():
	p1 = preload("res://scene/Plateau.tscn").instance()
	p1.largeur = GlobalLudo.largeur
	p1.longueur = GlobalLudo.longueur
	GlobalLudo.Plateau = self
	add_child(p1)
	j1 = preload("res://scene/Joueur.tscn").instance()
	GlobalLudo.You = j1
func _on_toGame_pressed():
	for i in range(p1.largeur):
		GlobalLudo.plateauJoueur.append([])
		for j in range(p1.largeur):
			#print(p1.plateau[i][j])
			GlobalLudo.plateauJoueur[i].append(p1.plateau[i][j])
			GlobalLudo.plateauJoueur[i][j].modulate = Color(1, 0, 0)
	get_tree().change_scene("res://scene/Main.tscn")
