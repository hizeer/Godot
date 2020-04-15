extends CanvasLayer
var Time = OS.get_datetime()
var horaire= str(Time.hour)+":"+str(Time.minute)+":"+str(Time.second)	
var jour=(str(Time["day"])+ "/"+str(Time["month"])+ "/"+ str(Time["year"]))
onready var edit = get_node("Panel/TextEdit")		
onready var lab = get_node("Panel/ChatMain")

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Panel").hide()
	get_node("teteBox").hide()
	get_node("Panel/ChatMain").set_text(jour+"\n")

func _on_Button_pressed():
	send_text()	
	
sync func edit_text(texte):
	if (!texte.empty()):
		lab.set_text(lab.get_text()+horaire+"/ " + gamestate.infos_joueur.nom +" : " + texte +"\n")
		
func send_text():
	rpc("edit_text", edit.get_text())
	edit.set_text(String())

func _on_ButtonCroix_pressed():
	if get_node("Panel").is_visible_in_tree():
		get_node("Panel").hide()
		get_node("teteBox").hide()
		get_node("teteBox2").show()
	else:
		get_node("Panel").show()
		get_node("teteBox").show()
		get_node("teteBox2").hide()


#func _input(event):
#	if (!get_node("Panel/TextEdit").get_text().empty()):
#		if (Input.is_key_pressed(KEY_ENTER)):
#			_on_Button_pressed()

