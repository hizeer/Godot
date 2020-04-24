extends Control

var nbj = 2
var dureeTour = 30
var batailles = ["Bataille d'Aboukir","Bataille des Açores","Conquête des Açores","Bataille d'Agosta","Bataille d'Algésiras","Bataille d'Alicudi","Combat d'Antivari","Armada de 1779","Bataille d'Arnemuiden","Bataille de la baie de Bantry","Bataille de Barcelone","Bataille de Baru","Prise de Mỹ Tho","Bataille du rocher du Diamant","Bataille navale de Procida","Bataille du cap Béveziers","Bataille du cap Béveziers","Blocus du Saint-Laurent","Bombardement d'Alger","Bombardement de Salé","Bombardement de Tripoli","Combat du Bouvet et du Meteor","Bombardement de Cabinda","Campagne atlantique de mai 1794","Campagne méditerranéenne de 1798","Campagne navale dans la Manche","Bataille du canal de la Mona","Bataille du cap Finisterre","Bataille du cap Sicié","Bataille du cap Spartel","Bataille du Cap-Vert","Capture de York Factory","Bataille de Carthagène","Opération Catapult","Combat naval des îles Chausey","Bataille de Chef-de-Caux","Bataille de Cherchell","Bataille de la baie de Chesapeake","Bombardement de Chios","Croisière de Lamellerie","Bataille de Dakar","Bataille des Dardanelles","Bataille du détroit d'Otrante","Bataille du Dogger Bank","Bataille de la Dominique","Bataille de Douvres","Naufrage du Droits de l'Homme","Bataille du cap Dungeness","Combat de Dunkerque","Bataille de L'Écluse","Expédition de la baie d'Hudson","Bataille du cap Finisterre","Bataille des Formigues","Bataille de Fort Albany","Bataille de Fort-Royal","Bataille de Funchal","Bataille de la baie de Fundy","Combat du Généreux et du HMS Leander","Bataille de Gênes","Bombardement de Gênes","Bataille de Getaria","Poursuite du Goeben et du Breslau","Combat du golfe de Rosas","Bataille de Gondelour","Bataille de Gondelour","Bataille de Grand Port","Bataille de Grand Turk","Bataille de la Grenade","Bataille de Groix","Bataille du cap Henry","Bataille d'Hispaniola","Bataille de la Hougue","Bataille de la baie d'Hudson","Bataille des îles d'Hyères","Bataille de Jean-Rabel","Bataille de Koh Chang","Bataille de Lagos","Bataille de Lagos","Bataille des îles de Lérins","Libération de La Réunion","Bataille de Lissa","Bataille du cap Lizard","Bataille navale de Louisbourg","Bataille de Madagascar","Blocus de Malte","Combat de Malte du 24 août 1800","Bataille de Malte","Bataille de Marbella","Bataille de Margate","Bataille de la Martinique","Bataille de la Martinique","Attaque de Mers el-Kébir","Bataille des Mille-Îles","Bataille de Minorque","Bombardement de Mogador","Bataille de Muros","Raid sur Nassau","Bataille de Navarin","NCSM Athabaskan","NCSM Iroquois","Bataille de Négapatam","Bataille de Négapatam","Bataille de Négapatam","Bataille de Neuville","Bataille de la Vuelta de Obligado","Opération Posthorn","Opération Stonewall","Opération Vado","Bataille d'Orbetello","Bataille du cap Ortegal","Bataille d'Ouessant","Bataille d'Ouessant","Bataille de Palerme","Bataille de Papeete","Combat de Pelagosa","Combat de Penang","Combat de Pirano","Bataille de Pondichéry","Bataille de Ponza","Bataille de Porto Praya","Bataille de Poulo Aura","Bataille de Provédien","Raid sur Gênes","Combat de Reggio","Bataille de Rio de Janeiro","Bataille de Rio de Janeiro","Bataille de la Ristigouche","Premier combat de la Rivière Noire","Bataille du cap de la Roque","Bataille des Sables-d'Olonne","Bataille de Sadras","Bataille de Saint-Mathieu","Bataille de Saint-Christophe","Blocus de Saint-Domingue","Attaque de Saint-Paul","Attaque de Sainte-Rose","Bataille des Saintes","Bataille de San Domingo","Bataille de San Juan de Ulúa","Bataille de Sandwich","Bataille de Santa Marta","Bataille de Schooneveld","Première bataille de Schooneveld","Seconde bataille de Schooneveld","Bombardement de Shimonoseki","Combat de Shipu","Bataille de Solebay","Bataille du Solent","Bataille du Stromboli","Bataille de Syracuse","Combat du Tage","Bataille de Tarragone","Expédition à Terre-Neuve","Bataille du Texel","Bataille du Texel","Bataille de Tabago","Bataille de l'île de Toraigh","Combat de Tortosa","Bataille de Tourane","Bataille de Trafalgar","Bataille de Trinquemalay","Bataille de Vado","Bataille navale de Vélez-Málaga","Bataille navale de Vigo","Combat de Vizagapatam","Bataille de Zierikzee"]
var nomPartie
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	nomPartie = batailles[int(rand_range(0,batailles.size()))]
	infosGlobales.nomPartie = nomPartie
	get_node("Panel/Label").set_text(nomPartie)
	get_node("Panel2/Label").set_text(str(dureeTour / 60)+"m "+str(dureeTour % 60)+"s" )
	get_node("Panel3/Label").set_text(str(nbj))


func _on_PopupMenu2_id_pressed(id):
	dureeTour = id
	get_node("Panel2/Label").set_text(str(dureeTour / 60)+"m "+str(dureeTour % 60)+"s" )


func _on_PopupMenu_id_pressed(id):
	nbj = id
	get_node("Panel3/Label").set_text(str(nbj))


func _on_Button3_pressed():
	var upnp = UPNP.new()
	var port
	upnp.discover(6000, 2, "InternetGatewayDevice")
	port = findPort(upnp,32500,65000)
	
	var headers = ["port: "+str(port),"type: make","maxPlayers:"+str(nbj),"dureetour:"+str(dureeTour),"nompartie:"+nomPartie]
	infosGlobales.serverPort = port
	infosGlobales.infosPartie["maxPlayers"] = nbj
	infosGlobales.infosPartie["dureeTour"] = dureeTour
	infosGlobales.nomPartie = nomPartie
	
	$HTTPRequest.request("http://www.achline.fr:58080/",headers)


func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
	infosGlobales.isServer = true
	infosGlobales.selectedGame = body.get_string_from_utf8()
	print(body.get_string_from_utf8())
	get_tree().change_scene("res://scene/attente.tscn")


func _on_Button4_pressed():
	get_tree().change_scene("res://scene/menuSylv.tscn")


func findPort(var upnp, var pas, var pmax):
	var i = pas
	while(i < pmax):
		if(upnp.add_port_mapping(i) == 0):
			return (i)
		i+=pas
	return(findPort(upnp, int(pas/2),pmax))

