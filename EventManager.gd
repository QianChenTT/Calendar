extends Node


signal event_created(event: Event)
var path:= "user://Events/"
var events: Dictionary = {}
var count := 0


func load_events():
	events = {}
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print_debug("Found directory: " + file_name)
			else:
				print_debug("Found file: " + file_name)
				var event: Event = ResourceLoader.load(ProjectSettings.globalize_path(path + file_name), "Event")
				add_event(event)
			file_name = dir.get_next()
	else:
		print_debug("An error occurred when trying to access the path.")


func save_all_events():
	#OS.move_to_trash(ProjectSettings.globalize_path(path))
	DirAccess.make_dir_absolute(path)
	for year in events:
		for month in events[year]:
			for day in events[year][month]:#day is an array of events
				for event in events[year][month][day]:
					ResourceSaver.save(event, path + event.file_name)


func save_event(event: Event):
	ResourceSaver.save(event, path + event.file_name)


func delete_event(event: Event):
	var removed_event := DirAccess.remove_absolute(path + event.file_name)
	print(removed_event)
	events[event.date.year][event.date.month][event.date.day].erase(event)


func add_event(event: Event):
	if !events.has(event.date.year):
		events[event.date.year] = {}
	if !events[event.date.year].has(event.date.month):
		events[event.date.year][event.date.month] = {}
	if !events[event.date.year][event.date.month].has(event.date.day):
		events[event.date.year][event.date.month][event.date.day] = []
	events[event.date.year][event.date.month][event.date.day].append(event)
	count += 1


func get_day_events(date: Dictionary) -> Array:
	var daily_event := []
	#if !events.has(date.year):
		#return []
	#if !events[date.year].has(date.month):
		#return []
	#if !events[date.year][date.month].has(date.day):
		#return []
	for year in events.keys():
		for month in events[year].keys():
			for day in events[year][month].keys():
				for event in events[year][month][day]:
					var weekday = Time.get_datetime_dict_from_datetime_string("%04d-%02d-%02dT00:00:00"%[date.year, date.month, date.day], true).weekday
					match event.recurrent:
						Event.Recurrent.NONE:
							if event.date.year == date.year and event.date.month == date.month and event.date.day == date.day:
								daily_event.append(event)
						Event.Recurrent.DAILY:
							daily_event.append(event)
						Event.Recurrent.WORK_DAYS:
							if weekday > Time.WEEKDAY_SUNDAY and weekday < Time.WEEKDAY_SATURDAY:
								daily_event.append(event)
						Event.Recurrent.WEEKENDS:
							if weekday == Time.WEEKDAY_SUNDAY or weekday == Time.WEEKDAY_SATURDAY:
								daily_event.append(event)
						Event.Recurrent.WEEKLY:
							if Time.get_datetime_dict_from_datetime_string("%04d-%02d-%02dT00:00:00"%[event.date.year, event.date.month, event.date.day], true).weekday == weekday:
								daily_event.append(event)
						Event.Recurrent.MONTHLY:
							if event.date.day == date.day or (event.date.day > Utility.num_of_days(date.month, date.year) and date.day == Utility.num_of_days(date.month, date.year)):
								daily_event.append(event)
						Event.Recurrent.YEARLY:
							if event.date.month == date.month and event.date.day == date.day:
								daily_event.append(event)
						Event.Recurrent.CUSTOM_DAYS:
							for custom_day in Event.Recurrent.YEARLY:
								if Time.get_datetime_dict_from_datetime_string("%04d-%02d-%02dT00:00:00"%[event.date.year, event.date.month, event.date.day], true).weekday == weekday:
									daily_event.append(event)
	return daily_event


func is_same_date(date1: Dictionary, date2: Dictionary) -> bool:
	return date1.year == date2.year and date1.month == date2.month and date1.day == date2.day
