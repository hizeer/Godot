extends Panel
onready var lastSize = Vector2(-1,-1)
var margin_value 
var hover = false setget SetHover
var panel = get_stylebox("panel", "" )
var border = 0
func Reposition():
	border = rect_size.y*0.1
	$MoveButton.rect_position= Vector2(border,border)
	$FireButton.rect_position = $MoveButton.rect_position + Vector2(rect_size.x/2,0)
	$MoveButton.rect_size = Vector2(rect_size.y*0.8,rect_size.y*0.8)
	$FireButton.rect_size = Vector2(rect_size.y*0.8,rect_size.y*0.8)
	border = ceil(border)
	panel.corner_radius_bottom_left=border*2
	panel.corner_radius_bottom_right=border*2
	panel.corner_radius_top_left=border*2
	panel.corner_radius_top_right=border*2

	panel.border_width_bottom=border
	panel.border_width_top=border
	panel.border_width_left=border
	panel.border_width_right=border

func SetHover(hov):
	hover = hov
	
func _ready():
# warning-ignore:return_value_discarded
	connect("item_rect_changed", self, "Reposition")
# warning-ignore:return_value_discarded
	connect("mouse_entered", self, "SetHover", [true])
# warning-ignore:return_value_discarded
	connect("mouse_exited", self, "SetHover", [false])
	print_debug(rect_size)
	Reposition()
	print_debug(rect_size)
func _input(event):
	if event is InputEventMouseButton:
		if !hover and event.pressed and event.button_index == BUTTON_LEFT :
			get_parent().queue_free()

