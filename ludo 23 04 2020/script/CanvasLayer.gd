extends CanvasLayer

func _ready():
	pass

func _on_Button_pressed():
	var headers = ["opp: mult","x: 6","y: 4"]
	
	#var query = JSON.print(data)
	$HTTPRequest.request("http://www.achline.fr:58080/",headers)

func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
	var json = JSON.parse(body.get_string_from_ascii())
	print(result)
	print("----")
	print(response_code)
	print("----")
	print(headers)
	print("----")
	print(body.get_string_from_ascii ( ))
	print("----")
	print(json.result)
