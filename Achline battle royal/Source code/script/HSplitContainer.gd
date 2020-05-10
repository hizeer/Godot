extends HSplitContainer


func Resize():
# warning-ignore:narrowing_conversion
	add_constant_override("separation", rect_size.x-2*rect_size.y) #pour que ces element reste ratio 1/1

func _ready():
# warning-ignore:return_value_discarded
	connect("item_rect_changed", self, "Resize")

