extends CanvasLayer
var Time = OS.get_datetime()
var time = str(Time.hour) + ":" + str(Time.minute) + ":" + str(Time.second)	
var day = (str(Time["day"]) + "/" + str(Time["month"]) + "/" + str(Time["year"]))
onready var notifications = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Panel").hide()
	get_node("teteBox").hide()
	get_node("Panel/ChatMain").set_text(day + "\n")
	get_node("menuchat").hide()
	
	var panel = get_node("Panel")
	
	get_node("menuchat/idmsg").connect("pressed",self,"_on_conv_pressed", [panel])
	panel.get_node("ButtonRetour").connect("pressed",self,"_on_ButtonRetour_pressed", [panel])
	panel.get_node("Button").connect("pressed",self, "_on_button_envoyer_pressed", [0])
	
	network.connect("_on_players_list_modifs", self, "_modification_private_channel")
	
sync func edit_text(text):
	var lab = get_node("Panel/ChatMain")
	
	lab.set_text(lab.get_text() + text)
	if !get_node("Panel").is_visible_in_tree():
		notifications += 1
		get_node("teteBox2/notification").text=str(notifications)
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
	else:
		notifications = 0
		get_node("teteBox2/notification").text=""

func send_text(id):
	var panel = get_panel(id)
	var edit = panel.get_node("TextEdit")
	var lab = panel.get_node("ChatMain")
	
	if (!edit.get_text().empty()):
		var msg = time+"/ " + gamestate.player_infos.name +" : " + edit.get_text() + "\n"
		if panel.get_meta("main") == id:
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

func _on_ButtonCroix_pressed():
	if(!get_node("teteBox2").is_visible_in_tree()):
		for c in get_node(".").get_children():
			c.hide()
			get_node("teteBox2").show()
			
	else:
		get_node("menuchat").show()
		get_node("teteBox").show()
		get_node("teteBox2").hide()


func _modification_private_channel():
	var dicoJoueur = network.players
	var dicoInfo = gamestate.infos_joueur

	for joueur in dicoJoueur.keys() :
			var tt = false;
			var i = 4;
			
			while (i < get_node(".").get_children().size() and tt == false):
					if get_node(".").get_child(i).has_meta("duplicate") and get_node(".").get_child(i).get_meta("duplicate") == int(joueur):
						tt = true
						
					elif get_node(".").get_child(i).has_meta("duplicate") and (not get_node(".").get_child(i).get_meta("duplicate") in dicoJoueur.keys()):
						get_node(".").get_child(i).queue_free()
						
						for bouton in get_node("menuchat/VBoxContainer").get_children():
							test_supression(get_node(".").get_child(i), bouton)
							
						tt = true
						
					else:
						i = i + 1
					
			if i == get_node(".").get_children().size() and int(joueur) != dicoInfo.get("net_id"):
					var bouton = Button.new()
					
					var Joueur = dicoJoueur.get(joueur)
					bouton.set_text(Joueur.nom)
		
					var panel  = load("res://Panel duplicate.tscn").instance()
					panel.set_id(int(joueur))
							
					var boutonenvoyer = panel.get_node("Button")
					var boutonretour = panel.get_node("ButtonRetour")
								
					bouton.connect("pressed", self, "_on_conv_pressed", [panel])
					boutonretour.connect("pressed",self,"_on_ButtonRetour_pressed",[panel])
					boutonenvoyer.connect("pressed",self, "_on_button_envoyer_pressed", [Joueur.net_id])
				
					get_node("menuchat/VBoxContainer").add_child(bouton)
					get_node(".").add_child(panel)

func _on_ButtonRetour_pressed(panel: Panel):
	panel.hide()
	get_node("menuchat").show()
	
func test_supression(panel: Panel, bouton: Button):
	if (not panel.get_meta("duplicate") in network.players.keys()) and (not panel.has_meta("main") or panel.has_meta("duplicate")):
		bouton.disabled = true
		bouton.queue_free()

func _on_conv_pressed(panel : Panel):
	if (panel.get_meta("duplicate") in network.players.keys()) or (panel.has_meta("main")):
		get_node("menuchat").hide()
		panel.show()
	
func _on_button_envoyer_pressed(id):
	send_text(id)
