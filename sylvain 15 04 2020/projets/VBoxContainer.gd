extends MenuButton

var selectedGame

func _ready():
	pass


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	
	var lines = body.get_string_from_utf8().rsplit(",", false)
	print(body.get_string_from_utf8())
	
	for x in ["Game Id","Board Size","Joueur Max","Joueurs"]:
		add_child()
	
	for i in range(lines.size()) :
		var columns = lines[i].rsplit(" ", false)
		for y in range(columns.size()) :
			add_item(columns[y])
