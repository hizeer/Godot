extends Panel

func on_Window_Resize():
	$Panel.rect_size = Vector2(278, get_viewport().size.y)
	$Panel/CenterContainer.rect_size = $Panel.rect_size


func _ready():
	get_tree().get_root().connect("size_changed", self, "on_Window_Resize")
	on_Window_Resize()
