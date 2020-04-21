extends RichTextLabel
var timer
	
func _process(delta):
	if timer:
		text = String(timer.time_left)


func _on_Temps_restant_visibility_changed():
	timer = GlobalLudo.You.get_node("Timer")
