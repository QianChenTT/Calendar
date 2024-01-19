extends Popup

signal time_setting
signal create_event

func _ready():
	EventManager.event_created.connect(reset_input)
	position.x = ProjectSettings.get_setting("display/window/size/viewport_width")/2 - size.x/2
	position.y = ProjectSettings.get_setting("display/window/size/viewport_height")/4 - size.y + 1000


func _on_create_event():
	_close_window()
	create_event.emit()


func _close_window():
	hide()


#func _open_recurrence_settings_panel():
#	pass


#func _open_calendar():
#	$Popup.show()


func _open_time_setting_panel():
	time_setting.emit()


func reset_input(event: Event):
	%Name.text = ""
	%Tag.text = ""
