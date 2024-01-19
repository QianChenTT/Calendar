extends Node

var months := ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]


static func get_month_string(month: int) -> String:
	return Utility.months[month]


static func is_leap_year(year: int) -> bool:
	if year % 4 == 0:
		if year % 100 != 0:
			return true
		elif year % 400 == 0:
			return true
	return false


static func num_of_days(month: int, year: int) -> int:
	if month == 2:
		if is_leap_year(year):
			return 29
		return 28
	if month % 2 == 1 and month <= 7 or month % 2 == 0 and month > 7:
		return 31
	return 30


static func get_new_date(date: Dictionary, shift: int) -> Dictionary:
	date.day += shift
	date.weekday = ((date.weekday + shift)% 7 + 7) % 7
	if date.day < 1:
		if date.month == 1:
			date.day = 31 + date.day
			date.month = 12
			date.year -= 1
		else:
			date.day = num_of_days(date.month - 1, date.year) + date.day
			date.month -= 1
	elif date.day > num_of_days(date.month, date.year):
		if date.month == 12:
			date.day = date.day - 31
			date.month = 1
			date.year += 1
		else:
			date.day = date.day - num_of_days(date.month, date.year)
			date.month += 1
	return date


static func time_to_string(time: int) -> String:
	return "%d:%02d"%[time/60, time%60]

