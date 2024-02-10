extends Control

signal updated(dict)

var dict = {'0.01': 0, '0.05': 0, '0.1': 0, '0.5': 0, '1': 0, '2': 0, '5': 0,
			'10': 0, '20': 0, '50': 0, '100': 0, '200': 0, '500': 0, '1000': 0}
var history = []
var visible_history = false

func _ready():
	if FileAccess.file_exists("user://dict.tres"):
		dict = FileAccess.open("user://dict.tres", FileAccess.READ).get_var()
		update()
	if FileAccess.file_exists("user://history.tres"):
		history = FileAccess.open("user://history.tres", FileAccess.READ).get_var()
		load_history()

func _on_button_value_add(amount):
	dict[str(amount)] += 1
	var time = Time.get_datetime_dict_from_system()
	var min = time.minute
	if min  < 10: min = "0" + str(min)
	var hour = time.hour
	if hour  < 10: hour = "0" + str(hour)
	var day = time.day
	if day  < 10: day = "0" + str(day)
	var month = time.month
	if month  < 10: month = "0" + str(month)
	history.push_front({"text": "Ganhou {amount}MT às {h}:{m} de {d}/{mo}/{y}".format({"amount": amount, 
	"h": hour, "m": min, "d": day, "mo": month, "y": time.year}), "operation_add": true})
	update()
	added_history()
	save()

func added_history():
	var history_node = load("res://column.tscn") as PackedScene
	var new_column = history_node.instantiate()
	new_column.text = history[0].text
	new_column.operation_add = history[0].operation_add
	$HistoryScroll/History.add_child(new_column)
	$HistoryScroll/History.move_child(new_column, 0)

func load_history():
	var history_node = load("res://column.tscn") as PackedScene
	for history_column in history:
		var new_column = history_node.instantiate()
		new_column.text = history_column.text
		new_column.operation_add = history_column.operation_add
		$HistoryScroll/History.add_child(new_column)
		

func _on_image_add_value_reduce(amount):
	if dict[str(amount)] > 0: 
		dict[str(amount)] -= 1
		var time = Time.get_datetime_dict_from_system()
		var min = time.minute
		if min  < 10: min = "0" + str(min)
		var hour = time.hour
		if hour  < 10: hour = "0" + str(hour)
		var day = time.day
		if day  < 10: day = "0" + str(day)
		var month = time.month
		if month  < 10: month = "0" + str(month)
		history.push_front({"text": "Entregou {amount}MT às {h}:{m} de {d}/{mo}/{y}".format({"amount": amount, 
		"h": hour, "m": min, "d": day, "mo": month, "y": time.year}), "operation_add": false})
		update()
		added_history()
		save()

func update():
	var res = 0.0
	for i in dict.keys().map(func x(k):
		return float(k) * dict[k]):
		res += i
	$Balance.text = str(res)
	print(dict)
	emit_signal("updated", dict)

func save():
	var dict_save = FileAccess.open("user://dict.tres", FileAccess.WRITE)
	dict_save.store_var(dict)
	dict_save.close()
	var history_save = FileAccess.open("user://history.tres", FileAccess.WRITE)
	history_save.store_var(history)
	history_save.close()

func _on_actual_button_pressed():
	if visible_history == false:
		$HistoryShowHide.play("show")
		visible_history = true
	else:
		$HistoryShowHide.play("hide")
		visible_history = false
