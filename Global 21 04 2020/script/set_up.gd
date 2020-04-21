extends Control

export(NodePath) var dropdown_path
onready var dropdown = get_node(dropdown_path)

export(NodePath) var dense_button
onready var btn_dense = get_node(dense_button)

func add_items():
	dropdown.add_item("5")
	dropdown.add_item("7")
	dropdown.add_item("8")
	dropdown.add_item("10")
	btn_dense.add_item("dense")
	btn_dense.add_item("pas dense")

func on_item_selected(id):
	if id == 0:
		GlobalLudo.largeur = 5
		GlobalLudo.longueur = 5
	if id == 1:
		GlobalLudo.largeur = 7
		GlobalLudo.longueur = 7
	if id == 2:
		GlobalLudo.largeur = 8
		GlobalLudo.longueur = 8
	if id == 3:
		GlobalLudo.largeur = 10
		GlobalLudo.longueur = 10


func set_density(density):
	GlobalLudo.density = density + 1


func _ready():
	dropdown.connect("item_selected", self, "on_item_selected")
	add_items()
	btn_dense.connect("item_selected", self, "set_density")


func _on_Button_pressed():
	get_tree().change_scene("res://scene/placement.tscn")
