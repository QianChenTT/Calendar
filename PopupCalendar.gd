extends Popup

signal date_changed(date: Dictionary)

# Called when the node enters the scene tree for the first time.
func _ready():
	%Calendar.date_changed.connect(func(date: Dictionary):
		date_changed.emit(date)
		print("hi")
	)


func _on_popup_hide():
	pass
	#%Calendar._restore_to_current_date()
