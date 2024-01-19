extends Control

signal date_changed(date: Dictionary)
var code_change_for_git := 1
var code_changed_again := 10086

func _ready():
	%GridContainer.date_changed.connect(
		func(date: Dictionary): 
			date_changed.emit(date)
			update_month_label()
			)
	update_month_label()
	


func _month_decrement():
	%GridContainer.current_date.month -= 1
	if %GridContainer.current_date.month == 0:
		%GridContainer.current_date.year -= 1
		%GridContainer.current_date.month = 12
	%GridContainer.set_date(%GridContainer.current_date)
	date_changed.emit(%GridContainer.current_date)
	update_month_label()


func _month_increment():
	%GridContainer.current_date.month += 1
	if %GridContainer.current_date.month == 13:
		%GridContainer.current_date.year += 1
		%GridContainer.current_date.month = 1
	%GridContainer.set_date(%GridContainer.current_date)
	date_changed.emit(%GridContainer.current_date)
	update_month_label()


func print_smt():
	%GridContainer.set_date(Time.get_datetime_dict_from_system())
	print(%GridContainer.current_date)


func _restore_to_current_date():
	print("restoring")
	%GridContainer.set_date(Time.get_datetime_dict_from_system())
	update_month_label()


func update_month_label():
	%MonthYear.text = str(%GridContainer.current_date.month) + " / " + str(%GridContainer.current_date.year)
	

