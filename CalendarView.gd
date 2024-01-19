extends Control


func _ready():
	EventManager.load_events()
	%Daily.event_editor_requested.connect(func(event):
		$EventEditor.set_event(event)
		$EventEditor.show_editor()
	)
	$EventEditor.event_edit_requested.connect(_update_event)
	$EventEditor.event_edited.connect(func(editing_event):
		#EventManager.delete_event(editing_event)
		#EventManager.add_event(editing_event)
		EventManager.save_event(editing_event)
		%Daily.update_content(0)
		)

func _create_event():
	$EventCreator.edit_mode = EventCreator.Mode.CREATING
	$EventCreator.popup_centered()


func _update_event(event: Event) -> void:
	$EventCreator.edit_mode = EventCreator.Mode.EDITING
	$EventCreator.editing_event = event
	$EventCreator.popup_centered()
