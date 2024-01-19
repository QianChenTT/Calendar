extends Control

var event: Event 
var is_running := false


signal event_edit_requested(event: Event)
signal event_edited(event: Event)
enum State {HIDDEN, SHOWN, TRANSITIONING}
var state := State.HIDDEN

func _ready():
	await get_parent().ready
	position.x += custom_minimum_size.x #Anchored, screen size + custom min size
	#print(global_position)


func set_event(event: Event):
	self.event = event
	%Time.text = str(event.date.month) + " / " + str(event.date.day) + " " + Utility.time_to_string(event.start_time) + " to " + Utility.time_to_string(event.end_time)
	%Name.text = event.name
	%Description.text = event.description


func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if not get_rect().has_point(event.position):
			hide_editor()


func show_editor() -> void:
	if state != State.HIDDEN:
		return 
	state = State.TRANSITIONING
	var tween = create_tween()
	tween.chain().tween_property(self, "position", Vector2(position.x - custom_minimum_size.x, 0), 0.5)
	tween.chain().tween_callback(func():
		state = State.SHOWN
		)


func hide_editor() -> void:
	if state != State.SHOWN:
		return
	state = State.TRANSITIONING
	var tween = create_tween()
	tween.chain().tween_property(self, "position", Vector2(position.x + custom_minimum_size.x, 0), 0.5)
	tween.chain().tween_callback(func():
		state = State.HIDDEN
	)
	event.name = $VBoxContainer/Name.text
	event.description = $VBoxContainer/Description.text
	event_edited.emit(event)

func _open_calendar():
	event_edit_requested.emit(event)



