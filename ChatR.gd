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
	add_joueur_msg()



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
	

func envoyer():
	if (!edit.get_text().empty()):
		var msg = horaire+"/ " + gamestate.infos_joueur.nom +" : " + edit.get_text()+"\n"
		chat_afficher(msg)
		edit.text=""
		for id in network.players:
			rpc_id(id,"chat_afficher",msg)
		

	




func _on_ButtonCroix_pressed():
	if get_node("Panel").is_visible_in_tree() or get_node("menuchat").is_visible_in_tree():
		get_node("Panel").hide()
		get_node("teteBox").hide()
		get_node("menuchat").hide()
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
	
	
remote func ajout_joueur_msg(nom):
	get_tree().get_node("menuchat").add_child(Button).text=nom
	

func add_joueur_msg():
	for id in network.players:
		var nm= str(id)
		if id != 1:
			rpc_id(id,"ajout_joueur_msg",nm)
			print("je suis ici")

		


func _on_idmsg_pressed():
	get_node("menuchat").hide()
	get_node("Panel").show()
