extends Control

var scene

func _ready():
	GlobalLudo.Reload()
	gamestate.Reload()
	infosGlobales.Reload()
	network.Reload()

func _on_Jouer_pressed():
	if GlobalLudo.bruitages:
		get_node("menu_conteneur/centre/boutons/Jouer/click").play()
	$fadeIn.show()
	$fadeIn.fade_in()
	scene = "res://scene/menuSylv.tscn"



func _on_Options_pressed():
	if GlobalLudo.bruitages:
		get_node("menu_conteneur/centre/boutons/Options/click").play()
	$fadeIn.show()
	$fadeIn.fade_in()
	scene = "res://scene/options.tscn"


func _on_Crdits_pressed():
	if GlobalLudo.bruitages:
		get_node("menu_conteneur/centre/boutons/Crédits/click").play()
	$fadeIn.show()
	$fadeIn.fade_in()
	scene = "res://scene/Crédits.tscn"


func _on_Quitter_pressed():
	if GlobalLudo.bruitages:
		get_node("menu_conteneur/centre/boutons/Quitter/click").play()
	$fadeIn.show()
	$fadeIn.fade_in()
	get_tree().quit()


func _on_fadeIn_fade_finished():
	get_tree().change_scene(scene)
