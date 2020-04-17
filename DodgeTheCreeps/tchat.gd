extends CanvasLayer
var Time = OS.get_datetime()
var time = str(Time.hour) + ":" + str(Time.minute) + ":" + str(Time.second)	
var day = (str(Time["day"]) + "/" + str(Time["month"]) + "/" + str(Time["year"]))
onready var edit = get_node("Panel/TextEdit")
onready var lab = get_node("Panel/ChatMain")
onready var notifications=0
signal mouse_up
signal mouse_down

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Panel").hide()
	get_node("teteBox").hide()
	get_node("Panel/ChatMain").set_text(day + "\n")
	get_node("menuchat").hide()
	network.connect("modification_liste_joueurs", self, "_modification_private_channel")

func _on_Button_pressed():
	send_text()
	
sync func edit_text(text):
	if (!text.empty()):
		lab.set_text(lab.get_text()+text)
		if !get_node("Panel").is_visible_in_tree():
			notifications += 1
			get_node("teteBox2/notification").text=str(notifications)
		else:
			notifications = 0
			get_node("teteBox2/notification").text=""

remote func edit_text_private(panel, text, chatMain):
	chatMain.set_text(chatMain.get_text() +text)
	if !panel.is_visible_in_tree():
		notifications+=1
		get_node("teteBox2/notification").text=str(notifications)
	else:
		notifications=0
		get_node("teteBox2/notification").text=""


func send_text():
	if (!edit.get_text().empty()):
		var msg = time+"/ " + gamestate.infos_joueur.nom +" : " + edit.get_text()
		rpc("edit_text", msg)
		edit.set_text(String())

func send_text_private(panel, id, textEdit, chatMain):
	if (!textEdit.get_text().empty()):
		var msg = time + "/ " + gamestate.infos_joueur.nom +" : " + textEdit.get_text()+"\n"
		edit_text_private(panel, msg, chatMain)
		
		var rpc_player_panel = rpc_id(id,"get_panel",gamestate.infos_joueur.net_id)
		
		rpc_id(id,"edit_text_private",rpc_player_panel ,msg, rpc_player_panel.get_child(0))
		textEdit.set_text(String())


remote func get_panel(id):
	for node in get_node(".").get_children():
		if node is Panel and node.get_meta("duplicate") == id:
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

func _on_ButtonRetour_pressed():
	get_node("menuchat").show()
	get_node("Panel").hide()

func _modification_private_channel():
	for button in get_node("menuchat/VBoxContainer").get_children():
		button.queue_free()
	
	var dicoJoueur = network.players
	var dicoInfo = gamestate.infos_joueur
	
	for joueur in dicoJoueur.keys() :
		if (int(joueur) != dicoInfo.get("net_id")):
			
			var bouton = Button.new()
			
			var Joueur = dicoJoueur.get(joueur)
			bouton.set_text(Joueur.nom)
			
			var panel  = load("res://Panel duplicate.tscn").instance()
			panel.set_id(int(joueur))
			
			var chatMain = panel.get_child(0)
			chatMain.set_text(String())
			
			var textEdit = panel.get_child(1)
			var boutonenvoyer = panel.get_child(2)
			var boutonretour = panel.get_child(4)
			
			bouton.connect("pressed", self, "_on_conv_privee_pressed", [panel])
			boutonretour.connect("pressed",self,"_on_ButtonRetour_private_pressed",[panel])
			boutonenvoyer.connect("pressed",self, "_on_button_envoyer_pressed", [panel, Joueur.net_id, textEdit, chatMain])
			
			get_node("menuchat/VBoxContainer").add_child(bouton)
			get_node(".").add_child(panel)


func _on_ButtonRetour_private_pressed(panel):
	panel.hide()
	get_node("menuchat").show()

func _on_idmsg_pressed():
	get_node("menuchat").hide()
	get_node("Panel").show()

func _on_conv_privee_pressed(panel):
	get_node("menuchat").hide()
	panel.show()
	
func _on_button_envoyer_pressed(panel, id, textEdit, chatMain):
	send_text_private(panel, id, textEdit, chatMain)
