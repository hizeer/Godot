extends Control
var combiNom = [["chien","chat","hamster","lapin","poisson","pingouin","ours","morse","phoque","éléphant","girafe","singe","crocodile","tigre","lion","rhinocéros","zèbre","cochon","vache","cheval","canard","poule","coq","chèvre","mouton","raie","tortue","dauphin","baleine","requin","méduse","orque","renard","oiseau","sanglier","loup","cerf","faon","hérisson","araignée","moustique","coccinelle","criquet","limace","escargot","sauterelle","godot","ludo","téo","kellian","fitahiana","sylvain"]
,["Absolu","Admirable","Agréable","Aimable","Amusant","Apocalyptique","Approximatif","Attachant","Aveugle","Banal","Bas","Bavarois","Bien","Bof","Bon","Bouleversant","Boute-en-train","Captivant","Caractériel","Cataclysmique","Catastrophique","Céleste","Charmant","Chouette","Commun","convenable","Convivial","Coquet","Correct","Crédible","Croquante","Cynique","Dégueulasse","Délectable","Délicieuse","Disjoncté","Divin","Douce","Doué","Drôle","Éblouissant","Ébouriffé","Efficace","Emballant","Émouvant","Endiablé","Ennuyant","Enragé","Enthousiasmant","Épatant","Époustouflant","Épouvantable","Équitable","Exaltant","Exceptionnel","Excusable","Exemplaire","Extra moelleux","Féru","Festif","Flamboyante","Formidable","Grandiose","Hardi","Honnête","Horrible","Important","Impressionnant","Inconnu","Incrédule","Indépendant","Infernal","Innommable","Insignifiant","Insuffisant","Insupportable","Intenable","Intéressant","Irrésistible","Libidineux","Louable","Majestueux","Magistral","Magnifique","Médiocre","Merdique","Merveilleux","Mignon","Minable","Mirobolante","Mortel","Moyen","Négligeable","Nul","Ordinaire","Original","Parfait","Pas pire","Passable","Passionnant","Percutant","Persévérant","Phénoménal","Placide","Plaisant","Prestant","Prodigieux","Proverbial","Quelconque","Ravissant","Recyclé","Relatif","Remarquable","Renversant","Revendicatrice","Révolutionnaire","Rocambolesque","Rutilant","Saint","Satisfaisant","Séduisant","Sexy","Somptueux","Spiritueux","Splendide","Suave","Sublime","Sulfureuse","Superbe","Suprême","Supportable","Talentueux","Tolérable","Tragique","Trépidant","Très bon","Troublant","Valable","Valeureux","Vénérable","Vitaminés","Vivable","Vulgaire"]]
var nom

func _ready():
	randomize()
	var lab = get_node("Label")
	nom = combiNom[0][int(rand_range(0,combiNom[0].size()))] + combiNom[1][int(rand_range(0,combiNom[1].size()))]
	nom =  nom.left(1).to_upper() + nom.right(1)
	
	infosGlobales.nomJoueur = nom
	lab.set_text(nom)


func _on_Button_pressed():
	get_tree().change_scene("res://scene/rejoindre.tscn")
	gamestate.name = nom


func _on_Button2_pressed():
	get_tree().change_scene("res://scene/creer.tscn")
	gamestate.name = nom
