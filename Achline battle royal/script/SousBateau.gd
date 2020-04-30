extends TextureRect
var onCase
var belongto = null
var damaged = false setget Destroy

func Destroy(val):
	var returnval = true
	damaged = val
	if damaged:
		belongto.canMove = false
		for sb in belongto.sousBatteaux:
			if !sb.damaged:
				returnval = false
		if returnval:
			belongto.destroyed = true
