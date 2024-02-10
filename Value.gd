extends VBoxContainer

@export var value: float
signal value_add(amount)
signal value_reduce(amount)

func _on_pressed():
	emit_signal("value_add", value)

func _on_main_updated(dict):
	$ImageAdd/Amount.text = str(dict[str(value)])

func _on_reduce_pressed():
	emit_signal("value_reduce", value)
