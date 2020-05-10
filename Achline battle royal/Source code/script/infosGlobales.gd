extends Node


var isServer = false
var selectedGame = ""
var nomPartie = "nom partie test"
var nomJoueur = "nom joueur Test"
var serverPort = 58054
var hoteip = ""
var ips = []
var infosPartie = {}

func Reload():
	isServer = false
	selectedGame = ""
	nomPartie = "nom partie test"
	nomJoueur = "nom joueur Test"
	serverPort = 58054
	hoteip = ""
	ips = []
	infosPartie = {}
