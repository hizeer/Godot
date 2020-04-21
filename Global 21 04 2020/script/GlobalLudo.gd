extends Node

var largeur = 5
var longueur = 5
var density = 2
var Id = -1
onready var You = preload("res://scene/Joueur.tscn").instance()
var Joueurs
var Plateau #reference a la node plateau
var Game #reference au script du jeu
# warning-ignore:unused_argument
