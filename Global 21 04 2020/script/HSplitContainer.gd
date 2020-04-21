extends HSplitContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func Resize():
	add_constant_override("separation", rect_size.x-2*rect_size.y) #pour que ces element reste ratio 1/1


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("item_rect_changed", self, "Resize")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
