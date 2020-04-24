extends Button



func _on_Button_pressed():
	if GlobalLudo.You.moving:
		
		GlobalLudo.You.moving.moving = false
		GlobalLudo.You.moving.Revert()
	GlobalLudo.Game.FinTour()
