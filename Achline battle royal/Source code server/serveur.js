var http = require('http');
var getIP = require('ipware')().get_ip;
var fs = require('fs');
 

var print = function(x){console.log(x)};



var contents = fs.readFileSync('options' ,'utf8'); //ouverture du fichier d'options
var options = contents.split(",");

var infosTemplate = new Map();

for(var i = 0;i<options.length;i++){ //lecture du fichier et création d'un dico type
	infosTemplate.set(options[i],"");
}

class Game{
	constructor(id,ip,port,infos){

		var i = 0;
		infos = infos.split(",");
		this.infos = new Map(infosTemplate);

		for (var [cle, valeur] of this.infos) {
			this.infos.set(cle,infos[i]);
			i++;
		}

		this.id = id;
		this.hostIp = ip;
		this.hostPort = port;
		this.nbTotJoueurs = parseInt(this.infos.get("maxplayers"));
		this.free = true; 
		this.nbPlayer = 1;

	}
	addPlayer(ip){
		if(this.free){
			this.nbPlayer += 1;

			console.log("nbPlayer : " );
			console.log(this.nbPlayer );
			console.log("nbTotJoueurs : " );
			console.log(this.nbTotJoueurs );
			console.log("this.nbPlayer == this.nbTotJoueurs : " );
			console.log(this.nbPlayer == this.nbTotJoueurs);


			if(this.nbPlayer == this.nbTotJoueurs){
				this.free = false;
			}
			return(true);
		} else{
			return(false); 
		}
	}
	removePlayer(ip){
		this.nbPlayer--;

		if(this.nbPlayer < this.nbTotJoueurs){
			this.free = true;
		}
	}
	isFree(){
		return(this.free);
	}
}

class GameList{
	constructor(){
		this.nbGame = 0;
		this.list = new Map();
		this.nextId = 0;
	}
	newGame(ip,port,infos){
		this.list.set(this.nextId , new Game(this.nextId, ip, port, infos));
		this.nextId++;
		this.nbGame++;
		return(this.nextId-1);
	}
	deleteGame(id){
		this.list.delete(id);
		this.nbGame--;
	}
	getGame(id){
		return(this.list.get(id));
	}
	getHostIp(id){
		return(this.list.get(id).hostIp);
	}
	getHostPort(id){
		return(this.list.get(id).hostPort);
	}
	addPlayerToGame(ip,id){
		if(this.list.get(id) != undefined){
			return(this.list.get(id).addPlayer(ip));
		} else{
			return(false);
		}

	}
	removePlayerFromGame(ip, id){
		if(this.list.get(id) != undefined){
			if(ip == this.list.get(id).hostIp){
				this.deleteGame(id);
			} else{
				this.list.get(id).removePlayer(ip);
			}
		}
	}
	printGames(){
		var tmp = "";

		for (var [cle, valeur] of this.list) {
			if(valeur.free){
				tmp+=valeur.id+",";
				for (var [cle2, valeur2] of valeur.infos) {
	  				tmp+=valeur2+",";
				}
				tmp+=valeur.nbPlayer + ";";
			}
		}
		return(tmp);
	}

	getGameIdFromIpOfPlayer(ip){
		for (var [cle, valeur] of this.list) {
			if(valeur.players.indexOf(ip) != -1){
				return(valeur.id);
			}
		}
	}

	isReadyToLaunch(id){
		return !(this.list.get(id).isFree());
	}

	getLaunchInfos(id){
		var tmp = "";

		for(var ip of this.list.get(id).players){
			tmp+=ip+" ";
		}

		console.log(tmp);
		return(tmp);
	}

}


//types de requettes possibles :

//creer partie       make
//rejoindre partie   join
//quiter partie      quit

//afficher parties   aff
//lancer la partie   launch
var parties = new GameList();

var server = http.createServer(function(req, res) {
	var type = req.headers["type"];
	var ip = getIP(req)["clientIp"].slice(7);
	if(ip == "192.168.1.254"){
		ip = "91.165.213.152"
	}

	res.writeHead(200);

	if(type == "make"){
		var newinfos = "";
		var port = req.headers["port"]
		console.log(port);
		for (var [cle, valeur] of infosTemplate) {
			newinfos+=req.headers[cle]+",";
		}

		var createdId = parties.newGame(ip,port,newinfos);
		res.write(createdId.toString(10));
	}
	if(type == "quit"){
		parties.removePlayerFromGame(ip,parseInt(req.headers["id"]));
	}

	if(type == "aff"){
		res.write(parties.printGames());
	}

	if(type == "join"){
		var id = parseInt(req.headers["id"]);

		if(parties.addPlayerToGame(ip,id)){
			res.write(parties.getHostIp(id)+","+parties.getHostPort(id));
		} else{
			res.write("full");
		}
	}

	

	
	res.end("");
});
server.listen(180);