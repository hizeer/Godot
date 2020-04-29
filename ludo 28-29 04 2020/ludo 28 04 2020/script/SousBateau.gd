extends TextureRect
var onCase
var belongto = null
var damaged = false setget Destroy

func Destroy(val):
	var returnval = true
	damaged = val
	if damaged:
		get_parent().canMove = false
		for sb in get_parent().Boats:
			if !sb.damaged:
				returnval = false
		if returnval:
			get_parent().destroyed = true
