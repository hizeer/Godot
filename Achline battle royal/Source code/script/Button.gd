extends Button

#Bouton FinTour

func _on_Button_pressed():
	if int(GlobalLudo.You.get_node("Timer").time_left) > 0:
		if GlobalLudo.You.moving:
			GlobalLudo.You.moving.moving = false
			GlobalLudo.You.moving.Revert()
		GlobalLudo.Game.FinTour()
