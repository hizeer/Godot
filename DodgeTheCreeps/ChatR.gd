extends CanvasLayer
var Time = OS.get_datetime()
var horaire= str(Time.hour)+":"+str(Time.minute)+":"+str(Time.second)	
var jour=(str(Time["day"])+ "/"+str(Time["month"])+ "/"+ str(Time["year"]))
onready var edit = get_node("Panel/TextEdit")		
onready var lab = get_node("Panel/ChatMain")
onready var notifications=0
signal mouse_up
signal mouse_down

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Panel").hide()
	get_node("teteBox").hide()
	get_node("Panel/ChatMain").set_text(jour+"\n")
	get_node("menuchat").hide()
	network.connect("modification_liste_joueurs", self, "_modification_private_channel")

func _on_Button_pressed():
	envoyer()	
	
remote func chat_afficher(text):
	lab.set_text(lab.get_text()+text)
	if !get_node("Panel").is_visible_in_tree():
		notifications+=1
		get_node("teteBox2/notification").text=str(notifications)
	else:
		notifications=0
		get_node("teteBox2/notification").text=""
		

remote func chat_afficher_private(panel, text, chatMain):
	chatMain.set_text(chatMain.get_text() +text)
	if !panel.is_visible_in_tree():
		notifications+=1
		get_node("teteBox2/notification").text=str(notifications)
	else:
		notifications=0
		get_node("teteBox2/notification").text=""

func envoyer():
	if (!edit.get_text().empty()):
		var msg = horaire+"/ " + gamestate.infos_joueur.nom +" : " + edit.get_text()+"\n"
		chat_afficher(msg)
		edit.text=""
		for id in network.players:
			rpc_id(id,"chat_afficher",msg)
			

func envoyer_private(panel, id, textEdit, chatMain):
	if (!textEdit.get_text().empty()):
		var msg = horaire+"/ " + gamestate.infos_joueur.nom +" : " + textEdit.get_text()+"\n"
		chat_afficher_private(panel, msg, chatMain)
		textEdit.text=""
		rpc_id(id,"chat_afficher_private",panel ,msg, chatMain)

func _on_ButtonCroix_pressed():
	if(!get_node("teteBox2").is_visible_in_tree()):
		for c in get_node(".").get_children():
			c.hide()
			get_node("teteBox2").show()
			
	else:
		get_node("menuchat").show()
		get_node("teteBox").show()
		get_node("teteBox2").hide()


func _input(event):
	if (Input.is_key_pressed(KEY_ENTER)):
		_on_Button_pressed()
		edit.text=""
	if (event is InputEventMouseButton and event.is_action_released("LMB")):
		emit_signal("mouse_up")
	elif event is InputEventMouseButton and Input.is_action_just_pressed("LMB"):
		emit_signal("mouse_down")


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
			bouton.text = Joueur.nom
			
			var panel  = get_node("Panel").duplicate()
			
			var chatMain = panel.get_child(0)
			chatMain.text = ""
			
			var boutonenvoyer = panel.get_child(2)
			
			var boutonretour = panel.get_child(4)
			
			var textEdit = panel.get_child(1)
			
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
	envoyer_private(panel, id, textEdit, chatMain)
