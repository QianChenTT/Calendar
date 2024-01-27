class_name DailyViewEventButton extends Button

signal event_editor_requested
signal event_edited

var event: Event:
	set(value):
		event = value
		$Name.text = event.name


var state = State.IDLE
var pivot: Vector2
var active := true

enum State {IDLE, DRAGGED}

func _ready():
	pass


func _process(delta):
	if state == State.DRAGGED:
		follow_mouse()
		$TimeLabel.text = Utility.time_to_string(position.y/DailyView.px_per_min) + " - "+ Utility.time_to_string(position.y/DailyView.px_per_min + event.duration)


func follow_mouse():
	position.y = get_parent().get_local_mouse_position().y - pivot.y
	position.y = snapped(position.y,DailyView.px_per_min * 5)
	position.y = clamp(position.y, 0, DailyView.px_per_min * (24 * 60 - event.duration))


func _on_button_down():
	$Timer.start()


func _on_timer_timeout():
	pivot = get_local_mouse_position()
	state = State.DRAGGED
	$TimeLabel.show()
	self.mouse_filter = Control.MOUSE_FILTER_STOP


func _on_button_up():
	if state == State.IDLE and active: # button has been pressed, but is not dragged. happens when timer didnt end
		event_editor_requested.emit()
	_on_mouse_exited()
	active = true
	var duration = event.duration
	event.start_time = position.y/DailyView.px_per_min
	event.end_time = event.start_time + duration
	event_edited.emit()


func _on_mouse_exited():
	state = State.IDLE
	self.mouse_filter = Control.MOUSE_FILTER_PASS
	$Timer.stop()
	$TimeLabel.hide()


