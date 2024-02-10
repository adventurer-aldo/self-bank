extends Panel

var text := ""
var operation_add := true

func _ready():
	$ScrollContainer/Label.text = text
	if operation_add == true:
		modulate = Color.DARK_GREEN
	else:
		modulate = Color.DARK_RED
