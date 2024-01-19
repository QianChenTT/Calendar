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
	if !events.has(date.year):
		return []
	if !events[date.year].has(date.month):
		return []
	if !events[date.year][date.month].has(date.day):
		return []
	return events[date.year][date.month][date.day]


func is_same_date(date1: Dictionary, date2: Dictionary) -> bool:
	return date1.year == date2.year and date1.month == date2.month and date1.day == date2.day
