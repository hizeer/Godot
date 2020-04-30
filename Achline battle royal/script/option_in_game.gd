extends Control


export(NodePath) var dropdown_path
onready var dropdown = get_node(dropdown_path)

export(NodePath) var button_fullscreen
onready var btn_full = get_node(button_fullscreen)

export(NodePath) var button_music
onready var btn_music = get_node(button_music)

export(NodePath) var button_buitages
onready var btn_bruitages = get_node(button_buitages)


func _ready():
	dropdown.connect("item_selected", self, "on_item_selected")
	add_items()
	btn_full.connect("toggled", self, "toggle_fullscreen")
	btn_music.connect("toggled", self, "toggle_musique")
	btn_bruitages.connect("toggled", self, "toggle_bruitages")
	btn_music.pressed = GlobalLudo.musique
	btn_bruitages.pressed = GlobalLudo.bruitages


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



func toggle_musique(pressed):
	if pressed:
		GlobalLudo.musique = true
	else:
		GlobalLudo.musique = false


func toggle_bruitages(pressed):
	if pressed:
		GlobalLudo.bruitages = true
	else:
		GlobalLudo.bruitages = false


func _on_Button_pressed():
	get_tree().quit()

func _process(delta):
	GlobalLudo.volume_musique = get_node("CenterContainer/Panel/VBoxContainer/music/CenterContainer/HSlider").value
	
