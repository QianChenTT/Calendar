class_name Event extends Resource


@export var name: String
@export var completed: bool
@export_multiline var description: String
@export_multiline var content: String
@export var tag: Array[StringName]
@export var date: Dictionary
@export var start_time: int
@export var end_time: int
var duration: int: #called on variable
	get:
		return end_time - start_time
@export var icon: Texture
@export var priority: Priority
@export var recurrent: Recurrent
var file_name: String

#event 1, event 2, event 2, event 3,event 8 , event 4, event 5, event 6, event 7
#year, month, date day(Mon Tu)
#[year][month][days]
#[1,2,3,4,5,6,7,8]

enum Priority{
	NO,
	LOW,
	MEDIUM,
	HIGH
}


enum Recurrent{
	NONE,
	DAILY,
	WORK_DAYS,
	WEEKENDS,
	WEEKLY,
	MONTHLY,
	YEARLY,
	CUSTOM_DAYS
}


func _init():
	date = {
		"year": 2023,
		"month": 5,
		"day" : 12,
	}
	self.file_name = "event" + str(EventManager.count) +".tres"
	start_time = 0
	end_time = 30
