extends CanvasLayer
var Time = OS.get_datetime()
var horaire= str(Time.hour)+":"+str(Time.minute)+":"+str(Time.second)	
var jour=(str(Time["day"])+ "/"+str(Time["month"])+ "/"+ str(Time["year"]))
onready var edit = get_node("Panel/TextEdit")		
onready var lab = get_node("Panel/ChatMain")
onready var notifications=0
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Panel").hide()
	get_node("teteBox").hide()
	get_node("Panel/ChatMain").set_text(jour+"\n")
	get_node("menuchat").hide()
	network.connect("modification_liste_joueurs",self,"modifications_compte")



func _on_Button_pressed():
	envoyer()	
	
func _on_Button_pressed_perso(edit2,lab2,id):
	send_private_message(edit2,lab2,id)
	
remote func chat_afficher(text):
	lab.set_text(lab.get_text()+text)
	if !get_node("Panel").is_visible_in_tree():
		notifications+=1
		get_node("teteBox2/notification").text=str(notifications)
	else:
		notifications=0
		get_node("teteBox2/notification").text=""
	
remote func chat_afficher_private(lab2,text):
	lab2.set_text(lab2.text+text)
	if !get_node("Panel").is_visible_in_tree():
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


func _on_ButtonRetour_pressed():
	get_node("menuchat").show()
	get_node("Panel").hide()
	
	
func _on_ButtonRetour2_pressed(panel):
	get_node("menuchat").show()
	panel.hide()

		
func send_private_message(edit2,lab2,id):
	if (!edit2.get_text().empty()):
		var msg = horaire+"/ " + gamestate.infos_joueur.nom +" : " + edit2.get_text()+"\n"
		chat_afficher_private(lab2,msg)
		edit2.text=""
		rpc_id(id,"chat_afficher_private",lab2,msg)

func _on_idmsg_pressed():
	get_node("menuchat").hide()
	get_node("Panel").show()
	

func _on_compte_private_pressed(panel,id):
	get_node("menuchat").hide()
	panel.show()
	

func modifications_compte():
	for button in get_node("menuchat/VBoxContainer").get_children():
		button.queue_free()
	var joueur=network.players
	var info = gamestate.infos_joueur
	for player in joueur.keys():
		if int(player) != info.get("net_id"):
			var bouton = Button.new()
			var panel = get_node("Panel").duplicate()
			get_node(".").add_child(panel)
			var chatmain = panel.get_child(0)
			chatmain.text=""
			var sujetchat= panel.get_child(3)
			var butonenvoyer = panel.get_child(2)
			var boutonretour = panel.get_child(4)
			boutonretour.connect("pressed",self,"_on_ButtonRetour2_pressed",[panel])
			var Joueur = joueur.get(player)
			var edit2= panel.get_child(1)
			var lab2=panel.get_child(0)
			
			bouton.text=Joueur.nom
			bouton.connect("pressed",self,"_on_compte_private_pressed",[panel,Joueur.net_id])
			butonenvoyer.connect("pressed",self,"_on_Button_pressed_perso",[edit2,lab2,Joueur.net_id])
			get_node("menuchat/VBoxContainer").add_child(bouton)
			
	
