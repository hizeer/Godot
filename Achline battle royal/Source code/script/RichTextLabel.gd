extends RichTextLabel
var timer
	
# warning-ignore:unused_argument
func _process(delta):
	if timer:
		text = String(int(timer.time_left))


func _on_Temps_restant_visibility_changed():
	timer = GlobalLudo.You.get_node("Timer")
