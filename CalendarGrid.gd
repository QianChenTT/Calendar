extends GridContainer


@export var date_button: PackedScene
signal date_changed(date: Dictionary)
var row := 6
var col := 7
var selected_date: Dictionary # the date that is selected
var current_date: Dictionary # date that the calendar is displaying
var group := ButtonGroup.new()

func _ready():
	#var group := ButtonGroup.new()
	for i in range(row):
		for j in range(col):
			var button: Button = date_button.instantiate()
			add_child(button)
			button.button_group = group
	selected_date = Time.get_datetime_dict_from_system()
	var day: int = selected_date.day
	set_date(selected_date)
	selected_date.day = day
	get_child(selected_date.day + current_date.weekday - 1).set_pressed(true)
	await get_tree().process_frame
	date_changed.emit(selected_date)


func set_date(date: Dictionary) -> void:
	date.day = 1
	var string := Time.get_datetime_string_from_datetime_dict(date, false)
	current_date = Time.get_datetime_dict_from_datetime_string(string, true)
	for i in range(row):
		for j in range(col):
			var button := get_child(i * 7 + j)
			if button.pressed.is_connected(update_date_info):
				button.pressed.disconnect(update_date_info)
			if i * 7 + j < current_date.weekday or i * 7 + j >= Utility.num_of_days(current_date.month, current_date.year) + current_date.weekday:
				button.disabled = true
				button.text = str("")
			else:
				button.disabled = false
				button.text = str(i * 7 + j - current_date.weekday + 1)
				button.pressed.connect(update_date_info.bind(int(button.text)))
		get_child(selected_date.day + current_date.weekday - 1).set_pressed(true)


func update_date_info(date: int) -> void:
	selected_date.day = date
	selected_date.month = current_date.month
	selected_date.year = current_date.year
	date_changed.emit(selected_date)
