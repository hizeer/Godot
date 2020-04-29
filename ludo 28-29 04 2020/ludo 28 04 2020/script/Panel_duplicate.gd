extends Panel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func set_id(id):
	set_meta("duplicate", id)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	set_meta("main", 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
