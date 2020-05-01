extends CanvasLayer
var Time = OS.get_datetime()
var time = str(Time.hour) + ":" + str(Time.minute) + ":" + str(Time.second)	
var day = (str(Time["day"]) + "/" + str(Time["month"]) + "/" + str(Time["year"]))
onready var notifications = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var panel = get_node("Panel")
	
	get_node("Panel").hide()
	get_node("teteBox").hide()
	get_node("Panel/ChatMain").set_text(day + "\n")
	get_node("menuchat").hide()
	get_node("Panel").set_meta("main",0)
	
	get_node("menuchat/HBoxContainerMain/CenterContainerChat/idmsg").connect("pressed",self,"_on_conv_pressed", [panel])
	panel.get_node("ButtonRetour").connect("pressed",self,"_on_ButtonRetour_pressed", [panel])
	panel.get_node("Button").connect("pressed",self, "_on_button_envoyer_pressed", [0])
	
	network.connect("_on_players_list_modifs", self, "_modification_private_channel")
	
	get_node("menuchat/HBoxContainerMain/CenterContaineMute/bouton_mute").connect("pressed",self,"_on_bouton_mute_pressed",[get_node("menuchat/HBoxContainerMain/CenterContaineMute/bouton_mute")])
	
sync func edit_text(text):
	var lab = get_node("Panel/ChatMain")
	lab.set_text(lab.get_text() + text)
	
	if !get_node("Panel").is_visible_in_tree():
		notifications += 1
		get_node("teteBox2/notification").text=str(notifications)
		if get_node("menuchat/HBoxContainerMain/CenterContaineMute/bouton_mute").icon == load("res://texture/icone_volume.png"):
			get_node("son_message").play()
	else:
		notifications = 0
		get_node("teteBox2/notification").text=""


remote func edit_text_private(id, text):
	var panel = get_panel(id)
	var lab = panel.get_node("ChatMain")
	lab.set_text(lab.get_text() + text)
	
	if !panel.is_visible_in_tree():
		notifications += 1
		get_node("teteBox2/notification").text=str(notifications)
		if get_bouton_volume(id).icon == load("res://texture/icone_volume.png"):
			get_node("son_message").play()
	else:
		notifications = 0
		get_node("teteBox2/notification").text=""


func send_text(id):
	var panel = get_panel(id)
	var edit = panel.get_node("TextEdit")
	var lab = panel.get_node("ChatMain")
	
	if (!edit.get_text().empty()):
		var msg = time+"/ " + gamestate.player_infos.name +" : " + edit.get_text() + "\n"
		if panel.has_meta("main") && panel.get_meta("main") == id:
			rpc("edit_text", msg)
			
		else:
			lab.set_text(lab.get_text() + msg)
			if !panel.is_visible_in_tree():
				notifications += 1
				get_node("teteBox2/notification").text=str(notifications)
			else:
				notifications = 0
				get_node("teteBox2/notification").text=""
			rpc_id(id,"edit_text_private",gamestate.player_infos.net_id, msg)
			
		edit.set_text(String())


func get_panel(id):
	for node in get_node(".").get_children():
		if node is Panel and node.has_meta("duplicate") and node.get_meta("duplicate") == id:
			return node
		if node is Panel and node.has_meta("main") and node.get_meta("main") == id:
			return node

func get_bouton_volume(id):
	for hbox in get_node("menuchat/VBoxContainer").get_children():
		for container in hbox.get_children():
			for bouton in container.get_children():
				if bouton.has_meta("volume") and bouton.get_meta("volume") == id:
					return bouton
	
func _on_ButtonCroix_pressed():
	if(!get_node("teteBox2").is_visible_in_tree()):
		for c in get_node(".").get_children():
			if not c is AudioStreamPlayer: 
				c.hide()
		get_node("teteBox2").show()
			
	else:
		get_node("menuchat").show()
		get_node("teteBox").show()
		get_node("teteBox2").hide()


func _modification_private_channel():
	var dicoJoueur = network.players
	var dicoInfo = gamestate.player_infos

	for joueur in dicoJoueur.keys() :
			var tt = false;
			var i = 5;
			
			while (i < get_node(".").get_children().size() and tt == false):
					if get_node(".").get_child(i).has_meta("duplicate") and get_node(".").get_child(i).get_meta("duplicate") == int(joueur):
						tt = true
						
					elif get_node(".").get_child(i).has_meta("duplicate") and (not get_node(".").get_child(i).get_meta("duplicate") in dicoJoueur.keys()):
						get_node(".").get_child(i).hide()
						
						for hbox in get_node("menuchat/VBoxContainer").get_children():
							for container in hbox.get_children():
								for bouton in container.get_children():
									if (bouton.has_meta("duplicate") && bouton.get_meta("duplicate") == get_node(".").get_child(i).get_meta("duplicate")) or (bouton.has_meta("volume") && bouton.get_meta("volume") == get_node(".").get_child(i).get_meta("duplicate")) :
										bouton.disabled = true
										bouton.queue_free()
										container.queue_free()
									
							get_node(".").get_child(i).queue_free()
							tt = true
						
					else:
						i = i + 1
					
			if i == get_node(".").get_children().size() and int(joueur) != dicoInfo.get("net_id"):
				var Joueur = dicoJoueur.get(joueur)
				
				var hbox = HBoxContainer.new()
				hbox.rect_size.x = 436
				hbox.rect_size.y = 41
				hbox.rect_min_size.x = 436
				hbox.rect_min_size.y = 41
				hbox.rect_position.x = 9
							
				var containerbouton = CenterContainer.new()
				containerbouton.rect_size.x = 375
				containerbouton.rect_size.y = 41
				containerbouton.rect_min_size.x = 375
				containerbouton.rect_min_size.y = 41
							
				var containermute = CenterContainer.new()
				containermute.rect_size.x = 47
				containermute.rect_size.y = 41
				containermute.rect_min_size.x = 47
				containermute.rect_min_size.y = 41
				containermute.rect_position.x = 380
							
				var bouton = Button.new()
				bouton.set_meta("duplicate",int(joueur))			
				bouton.set_text(Joueur.name)
				bouton.rect_size.x = 375
				bouton.rect_size.y = 41
				bouton.rect_min_size.x = 375
				bouton.rect_min_size.y = 41
				
				var panel  = load("res://scene/Panel_duplicate.tscn").instance()
				panel.set_meta("duplicate",int(joueur))
							
				var bouton_mute = Button.new()
				bouton_mute.icon = load("res://texture/icone_volume.png")
				bouton_mute.set_meta("volume",int(joueur))
				bouton_mute.rect_size.x = 47
				bouton_mute.rect_size.y = 41
				bouton_mute.rect_min_size.x = 47
				bouton_mute.rect_min_size.y = 41
				bouton_mute.rect_position.x = 380
							
				var boutonenvoyer = panel.get_node("Button")
				var boutonretour = panel.get_node("ButtonRetour")
										
				bouton.connect("pressed", self, "_on_conv_pressed", [panel])
				boutonretour.connect("pressed",self,"_on_ButtonRetour_pressed",[panel])
				boutonenvoyer.connect("pressed",self, "_on_button_envoyer_pressed", [Joueur.net_id])
				bouton_mute.connect("pressed", self, "_on_bouton_mute_pressed",[bouton_mute])
						
				get_node(".").add_child(panel)
							
				containerbouton.add_child(bouton)
				containermute.add_child(bouton_mute)
							
				hbox.add_child(containerbouton)
				hbox.add_child(containermute)
						
				get_node("menuchat/VBoxContainer").add_child(hbox)

func _on_ButtonRetour_pressed(panel: Panel):
	panel.hide()
	get_node("menuchat").show()
	
func _on_conv_pressed(panel : Panel):
	if (panel.has_meta("duplicate") and panel.get_meta("duplicate") in network.players.keys()) or (panel.has_meta("main")):
		get_node("menuchat").hide()
		panel.show()
	
func _on_button_envoyer_pressed(id):
	send_text(id)

func _on_bouton_mute_pressed(bouton: Button):
	if bouton.icon == load("res://texture/icone_volume_muted.png"):
		bouton.icon = load("res://texture/icone_volume.png")
	else:
		bouton.icon = load("res://texture/icone_volume_muted.png")
