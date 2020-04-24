extends Control

export(NodePath) var dropdown_path
onready var dropdown = get_node(dropdown_path)

export(NodePath) var button_fullscreen
onready var btn_full = get_node(button_fullscreen)


func _ready():
	dropdown.connect("item_selected", self, "on_item_selected")
	add_items()
	btn_full.connect("toggled", self, "toggle_fullscreen")


func add_items():
	dropdown.add_item("  1280 X 720  ")
	dropdown.add_item("  1360 X 768  ")
	dropdown.add_item("  1440 X 700  ")
	dropdown.add_item("  1680 X 1050  ")
	dropdown.add_item("  1920 X 1080  ")

func on_item_selected(id):
	if !OS.window_fullscreen:
		if id == 0:
			change_screen_size(1280, 720)
		if id == 1:
			change_screen_size(1360, 768)
		if id == 2:
			change_screen_size(1440, 700)
		if id == 3:
			change_screen_size(1680, 1050)
		if id == 4:
			change_screen_size(1920, 1080)


func toggle_fullscreen(pressed):
	if pressed:
		OS.window_fullscreen = true
	else:
		OS.window_fullscreen = false


func change_screen_size(x, y):
	OS.set_window_size(Vector2(x, y))


func _on_Retour_pressed():
	get_node("Options_conteneur/Retour/click").play()
	$fadeIn.show()
	$fadeIn.fade_in()
	


func _on_fadeIn_fade_finished():
	get_tree().change_scene("res://scene/Menu.tscn")
