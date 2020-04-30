extends CanvasLayer

var nbj = 2
var dureeTour = 30
var batailles = ["Bataille d'Aboukir","Bataille des Açores","Conquête des Açores","Bataille d'Agosta","Bataille d'Algésiras","Bataille d'Alicudi","Combat d'Antivari","Armada de 1779","Bataille d'Arnemuiden","Bataille de la baie de Bantry","Bataille de Barcelone","Bataille de Baru","Prise de Mỹ Tho","Bataille du rocher du Diamant","Bataille navale de Procida","Bataille du cap Béveziers","Bataille du cap Béveziers","Blocus du Saint-Laurent","Bombardement d'Alger","Bombardement de Salé","Bombardement de Tripoli","Combat du Bouvet et du Meteor","Bombardement de Cabinda","Campagne atlantique de mai 1794","Campagne méditerranéenne de 1798","Campagne navale dans la Manche","Bataille du canal de la Mona","Bataille du cap Finisterre","Bataille du cap Sicié","Bataille du cap Spartel","Bataille du Cap-Vert","Capture de York Factory","Bataille de Carthagène","Opération Catapult","Combat naval des îles Chausey","Bataille de Chef-de-Caux","Bataille de Cherchell","Bataille de la baie de Chesapeake","Bombardement de Chios","Croisière de Lamellerie","Bataille de Dakar","Bataille des Dardanelles","Bataille du détroit d'Otrante","Bataille du Dogger Bank","Bataille de la Dominique","Bataille de Douvres","Naufrage du Droits de l'Homme","Bataille du cap Dungeness","Combat de Dunkerque","Bataille de L'Écluse","Expédition de la baie d'Hudson","Bataille du cap Finisterre","Bataille des Formigues","Bataille de Fort Albany","Bataille de Fort-Royal","Bataille de Funchal","Bataille de la baie de Fundy","Combat du Généreux et du HMS Leander","Bataille de Gênes","Bombardement de Gênes","Bataille de Getaria","Poursuite du Goeben et du Breslau","Combat du golfe de Rosas","Bataille de Gondelour","Bataille de Gondelour","Bataille de Grand Port","Bataille de Grand Turk","Bataille de la Grenade","Bataille de Groix","Bataille du cap Henry","Bataille d'Hispaniola","Bataille de la Hougue","Bataille de la baie d'Hudson","Bataille des îles d'Hyères","Bataille de Jean-Rabel","Bataille de Koh Chang","Bataille de Lagos","Bataille de Lagos","Bataille des îles de Lérins","Libération de La Réunion","Bataille de Lissa","Bataille du cap Lizard","Bataille navale de Louisbourg","Bataille de Madagascar","Blocus de Malte","Combat de Malte du 24 août 1800","Bataille de Malte","Bataille de Marbella","Bataille de Margate","Bataille de la Martinique","Bataille de la Martinique","Attaque de Mers el-Kébir","Bataille des Mille-Îles","Bataille de Minorque","Bombardement de Mogador","Bataille de Muros","Raid sur Nassau","Bataille de Navarin","NCSM Athabaskan","NCSM Iroquois","Bataille de Négapatam","Bataille de Négapatam","Bataille de Négapatam","Bataille de Neuville","Bataille de la Vuelta de Obligado","Opération Posthorn","Opération Stonewall","Opération Vado","Bataille d'Orbetello","Bataille du cap Ortegal","Bataille d'Ouessant","Bataille d'Ouessant","Bataille de Palerme","Bataille de Papeete","Combat de Pelagosa","Combat de Penang","Combat de Pirano","Bataille de Pondichéry","Bataille de Ponza","Bataille de Porto Praya","Bataille de Poulo Aura","Bataille de Provédien","Raid sur Gênes","Combat de Reggio","Bataille de Rio de Janeiro","Bataille de Rio de Janeiro","Bataille de la Ristigouche","Premier combat de la Rivière Noire","Bataille du cap de la Roque","Bataille des Sables-d'Olonne","Bataille de Sadras","Bataille de Saint-Mathieu","Bataille de Saint-Christophe","Blocus de Saint-Domingue","Attaque de Saint-Paul","Attaque de Sainte-Rose","Bataille des Saintes","Bataille de San Domingo","Bataille de San Juan de Ulúa","Bataille de Sandwich","Bataille de Santa Marta","Bataille de Schooneveld","Première bataille de Schooneveld","Seconde bataille de Schooneveld","Bombardement de Shimonoseki","Combat de Shipu","Bataille de Solebay","Bataille du Solent","Bataille du Stromboli","Bataille de Syracuse","Combat du Tage","Bataille de Tarragone","Expédition à Terre-Neuve","Bataille du Texel","Bataille du Texel","Bataille de Tabago","Bataille de l'île de Toraigh","Combat de Tortosa","Bataille de Tourane","Bataille de Trafalgar","Bataille de Trinquemalay","Bataille de Vado","Bataille navale de Vélez-Málaga","Bataille navale de Vigo","Combat de Vizagapatam","Bataille de Zierikzee"]
var nomPartie
var ecartement = 2
var taillePlateau = 10
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	nomPartie = batailles[int(rand_range(0,batailles.size()))]
	infosGlobales.nomPartie = nomPartie
	get_node("Panel/Label").set_text(nomPartie)
	get_node("Panel2/Label").set_text(str(dureeTour / 60)+"m "+str(dureeTour % 60)+"s" )
	get_node("Panel3/Label").set_text(str(nbj))
	_on_PopupMenu2_id_pressed(dureeTour)
	_on_PopupMenu3_id_pressed(ecartement)
	_on_PopupMenu4_id_pressed(taillePlateau)
	_on_PopupMenu_id_pressed(nbj)


func _on_PopupMenu2_id_pressed(id):
	dureeTour = id
	get_node("Panel2/Label").set_text(str(dureeTour / 60)+"m "+str(dureeTour % 60)+"s" )
	get_node("Chrono/troteuse").rotation_degrees = id * 2;
	if GlobalLudo.bruitages:
		get_node("clic").play()


func _on_PopupMenu_id_pressed(id):
	var rot = [245.9,234,223.5,211.6,201,189.4,178.2,167,155.5,144.4,133.3,122.2,111.1,99.7,88.5,77.3,65.9,54.9,43.9,32.5,21.5]
	nbj = id
	get_node("Panel3/Label").set_text(str(nbj))
	get_node("CadranNBJ/aiguille").rotation_degrees = -rot[id];
	if GlobalLudo.bruitages:
		get_node("clic").play()
	
func _on_PopupMenu3_id_pressed(id):
	ecartement = id
	var txt = ""
	
	if(id == 1):
		txt = "Serré"
		get_node("compas/AnimatedSprite").frame = 0
	if(id == 2):
		txt = "Normal"
		get_node("compas/AnimatedSprite").frame = 1
	if(id == 3):
		txt = "Ecarté"
		get_node("compas/AnimatedSprite").frame = 2

	
	GlobalLudo.density = id
	get_node("Panel4/Label").set_text(txt)
	
	
	
	if GlobalLudo.bruitages:
		get_node("clic").play()


func _on_PopupMenu4_id_pressed(id):
	if GlobalLudo.bruitages:
		get_node("clic").play()
	taillePlateau = id
	var txt = ""
	if(id == 5):
		txt = "puzzle"
		get_node("huile/auguilleahuile").rotation_degrees = -90.1;
	if(id == 8):
		txt = "Petit"
		get_node("huile/auguilleahuile").rotation_degrees = -52.3;
	if(id == 10):
		txt = "Moyen"
		get_node("huile/auguilleahuile").rotation_degrees = 0;
	if(id == 15):
		txt = "Grand"
		get_node("huile/auguilleahuile").rotation_degrees = 52.4;
	if(id == 20):
		txt = "Très grand"
		get_node("huile/auguilleahuile").rotation_degrees = 89.5;
	
	GlobalLudo.largeur = id
	GlobalLudo.longueur = id
	get_node("Panel5/Label").set_text(txt)
	

func _on_Button3_pressed():
	if GlobalLudo.bruitages:
		get_node("clic").play()
	var upnp = UPNP.new()
	var port
	upnp.discover(6000, 2, "InternetGatewayDevice")
	port = findPort(upnp,32500,65000)
	
	var headers = ["port: "+str(port),"type: make","maxPlayers:"+str(nbj),"dureetour:"+str(dureeTour),"nompartie:"+nomPartie,"ecartement:"+str(ecartement),"tailleplateau:"+str(taillePlateau)]
	infosGlobales.serverPort = port
	infosGlobales.infosPartie["maxPlayers"] = nbj
	infosGlobales.infosPartie["dureeTour"] = dureeTour
	infosGlobales.infosPartie["ecartement"] = ecartement
	infosGlobales.infosPartie["taillePlateau"] = taillePlateau
	infosGlobales.nomPartie = nomPartie
	
	$HTTPRequest.request("http://www.achline.fr:58080/",headers)
	


func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
	infosGlobales.isServer = true
	infosGlobales.selectedGame = body.get_string_from_utf8()
	get_tree().change_scene("res://scene/attente.tscn")


func _on_Button4_pressed():
	if GlobalLudo.bruitages:
		get_node("click").play()
	$fadeIn.show()
	$fadeIn.fade_in()


func findPort(var upnp, var pas, var pmax):
	var i = pas
	while(i < pmax):
		if(upnp.add_port_mapping(i) == 0):
			return (i)
		i+=pas
	return(findPort(upnp, int(pas/2),pmax))



func _on_fadeIn_fade_finished():
	get_tree().change_scene("res://scene/menuSylv.tscn")
