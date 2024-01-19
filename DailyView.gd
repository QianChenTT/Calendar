class_name DailyView extends VBoxContainer


var time_label_offset := 35.0
var time_labels: Array[Label]
var date: Dictionary
var real_time_date: Dictionary
var event_timeline_gap := 15
var time_label_gap = 1
var event_buttons: Array[DailyViewEventButton] = []
var time_label_scene := preload("res://TimeLabel.tscn")
var event_scene := preload("res://DailyViewEventButton.tscn")

static var px_per_min := 5.0
signal event_editor_requested(event)


func _ready():
	date = Time.get_date_dict_from_system()
	real_time_date = Time.get_datetime_dict_from_system()
	$Timer.timeout.connect(update_timeline)
	await get_tree().root.ready
	for i in range(24 * 4):
		var time_label := time_label_scene.instantiate()
		time_labels.append(time_label)
		time_label.text = "%02d:%02d" % [i/4, (i * 15) % 60]
		%TimeLabels.add_child(time_label)
	
	EventManager.event_created.connect(
		func(event: Event): 
			if EventManager.is_same_date(event.date, date):
				#create_event_button(event)
				update_content(0)
	)
	
	update_content(0)


func update_display():
	var relative_position: float = $ScrollContainer.scroll_vertical / %EventPanelHolder.custom_minimum_size.y
	%EventPanelHolder.custom_minimum_size = Vector2(0, 24 * 60 * px_per_min)
	$ScrollContainer.scroll_vertical = %EventPanelHolder.custom_minimum_size.y * relative_position
	for i in range(24 * 4):
		if i%time_label_gap == 0: 
			time_labels[i].show()
		else:
			time_labels[i].hide()
		time_labels[i].position = Vector2(0, px_per_min * i * 15 - time_label_offset)
	
	for i in range(%HourLines.get_child_count()):
		%HourLines.get_child(i).position.y = px_per_min * i * 60
		
	for button in event_buttons:
		button.position = Vector2(0, px_per_min * button.event.start_time)
		#time_labels[0].size.x + event_timeline_gap
		button.size.y = px_per_min * button.event.duration
		#button.set_deferred("size:y", px_per_min * button.event.duration)
	update_timeline()



func update_content(shift: int):
	date = Utility.get_new_date(date, shift)
	%Date.text = "%d/%d/%d" % [date.day, date.month, date.year]
	var daily_events := EventManager.get_day_events(date)
	
	for control in %EventPanel.get_children():
		control.queue_free()
	await get_tree().process_frame
	event_buttons = []
	for event in daily_events:
		create_event_button(event)
	sort_buttons()
	update_display()
	%WeekDayButtons.get_child(date.weekday).get_child(0).set_pressed(true)


func create_event_button(event: Event):
	var event_button := event_scene.instantiate()
	event_button.event = event
	event_button.mouse_filter = Control.MOUSE_FILTER_PASS
	event_buttons.append(event_button)
	event_button.add_to_group("EventButtonGroup")
	$ScrollContainer.scroll_started.connect(
		func():
			event_button._on_mouse_exited()
			event_button.active = false
	)
	
	event_button.event_editor_requested.connect(
		func():
			event_editor_requested.emit(event_button.event)
	)
	
	event_button.event_edited.connect(
		func():
			update_content(0)
	)
#	%EventPanel.get_child(0).add_child(event_button)


func zoom_in():
	if px_per_min <= 6.2:
		px_per_min += 0.4
		
		if px_per_min > 3.4:
			time_label_gap = 1
		update_display()


func zoom_out():
	if px_per_min > 2:
		px_per_min -= 0.4
		
		if px_per_min <= 3.4:
			time_label_gap = 4
		update_display()


func update_timeline():
	if date.day == real_time_date.day and date.month == real_time_date.month and date.year and real_time_date.year:
		%TimeLine.position.y = (real_time_date.hour * 60 + real_time_date.minute) * px_per_min
		%TimeLine.show()
	else:
		%TimeLine.hide()


func compare_to(e1: DailyViewEventButton, e2: DailyViewEventButton) -> bool:
	return e1.event.end_time < e2.event.end_time


func sort_buttons() -> void:
	event_buttons.sort_custom(compare_to)
	var col := 0
	var button_counter := 0	
	while button_counter != event_buttons.size():
		var end_time := 0
		for button in event_buttons:
			if button.event.start_time < end_time or button.get_parent() != null:
				continue
			if %EventPanel.get_child_count() == col:
				var control = Control.new()
				control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				control.mouse_filter = Control.MOUSE_FILTER_IGNORE
				%EventPanel.add_child(control)
			%EventPanel.get_child(col).add_child(button)
			end_time = button.event.end_time
			button_counter += 1
		col += 1


func _unhandled_input(event):
	if event.is_action_pressed("zoom_in"):#Z
		zoom_in()
	if event.is_action_pressed("zoom_out"):#X
		zoom_out()


func _on_weekday_pressed(weekday: int):
	update_content(weekday - date.weekday)


