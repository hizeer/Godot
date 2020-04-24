extends Button
var Activated = false setget RefreshButton


func RefreshButton(val):
	Activated = val
	if Activated:
		text = "Ready"
		set("custom_colors/font_color", Color(0,1,0))
	else:
		text = "Not Ready"
		set("custom_colors/font_color", Color(1,0,0))
func _on_toGame_pressed():
	if Activated:
		self.Activated = false
		GlobalLudo.Game.rpc_id(1,"DecreaseWait")
	else:
		self.Activated = true
		GlobalLudo.Game.rpc_id(1,"IncreaseWait")
