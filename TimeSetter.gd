extends Control

var pressed: VBoxContainer
var px_per_min: float
var min_x: float
var max_x: float
var start_time := 0:
	set(value):
		start_time = value
		reinitialize()
		%StartTime_label.text = Utility.time_to_string(start_time)
var end_time := 24*60:
	set(value):
		end_time = value
		reinitialize()
		%EndTime_label.text = Utility.time_to_string(end_time)
var button_size: int


func _ready():
	await get_tree().process_frame 
	reinitialize()
	get_tree().root.size_changed.connect(reinitialize)


func _process(delta):
	if pressed != null:
		pressed.position.x = get_local_mouse_position().x - button_size/2
		update()


func _on_start_time_btn_button_down():
	pressed = $StartTime


func _on_start_time_btn_button_up():
	pressed = null


func _on_end_time_btn_button_down():
	pressed = $EndTime


func _on_end_time_btn_button_up():
	pressed = null


func reinitialize()-> void:
	button_size = $StartTime.size.x
	min_x = button_size
	max_x = size.x - button_size
	px_per_min = ((max_x - min_x)/24.0)/60.0
	$StartTime.position.x = px_per_min * start_time
	$EndTime.position.x = min_x + px_per_min * end_time



func update()-> void:
	if pressed == $StartTime:
		pressed.position.x = clamp(pressed.position.x, min_x - button_size, $EndTime.position.x - button_size - 5*px_per_min)
		pressed.position = pressed.position.snapped(Vector2((px_per_min*5), 1))
		start_time = round((pressed.position.x + button_size - min_x)/px_per_min)
		%StartTime_label.text = Utility.time_to_string(start_time)
	elif pressed == $EndTime:
		pressed.position.x = clamp(pressed.position.x, $StartTime.position.x + button_size + 5*px_per_min, max_x)
		pressed.position.x = max_x - (snapped(max_x - pressed.position.x, 5*px_per_min))
		end_time = round((pressed.position.x - min_x)/px_per_min)
		%EndTime_label.text = Utility.time_to_string(end_time)
