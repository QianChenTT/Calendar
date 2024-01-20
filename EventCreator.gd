class_name EventCreator extends Popup

var current_date: Dictionary

enum Mode {CREATING, EDITING}

var edit_mode := Mode.CREATING
var editing_event: Event


func _ready():
	EventManager.event_created.connect(func(event: Event): reset_input())
	$PopupCalendar.date_changed.connect(_on_date_changed)


func _close_window():
	reset_input()
	hide()


func _on_date_changed(date: Dictionary):
	%MonthDayYear.text = "%s/%s/%s" %[date.day, date.month, date.year]
	current_date = date

func reset_input():
	%Name.text = ""
	%Description.text = ""
	%MonthDayYear.text = ""
	%STHour.value = 0
	%STMinute.value = 0
	%ETHour.value = 0
	%ETMinute.value = 0
	%TimeSetter.start_time = 0
	%TimeSetter.end_time = 60 * 24
	#%TimeSetter.get_child(0).get_child(0).text = Utility.time_to_string(0)
	#%TimeSetter.get_child(1).get_child(0).text = Utility.time_to_string(60 * 24)
	%OptionButton.selected = 0
	$PopupCalendar.get_child(0).get_child(0).print_smt()
	_on_date_changed(Time.get_date_dict_from_system())


func _on_create_event():
	if edit_mode == Mode.CREATING:
		var event: Event = Event.new()
		set_event_info(event)
		EventManager.add_event(event)
		EventManager.save_event(event)
		EventManager.event_created.emit(event)
	else:
		print("ran")
		EventManager.delete_event(editing_event)
		set_event_info(editing_event)
		EventManager.add_event(editing_event)
		EventManager.save_event(editing_event)
		EventManager.event_created.emit(editing_event)
	_close_window()


func set_event_info(event: Event):
	event.name = %Name.text
	event.completed = false
	event.description = %Description.text
	#event.tag.append("%Tag").text
	event.date.year = current_date.year
	event.date.month = current_date.month
	event.date.day = current_date.day
	event.start_time = %TimeSetter.start_time
	event.end_time = %TimeSetter.end_time
	event.recurrent = %OptionButton.selected
	print(event.recurrent)


func _open_calendar():
	$PopupCalendar.popup_centered()


func _on_popup_hide():
	var is_shown = $PopupCalendar.visible
	await get_tree().process_frame
	if is_shown:
		show()
