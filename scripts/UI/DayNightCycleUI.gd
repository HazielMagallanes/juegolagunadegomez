extends Control


@onready var dayLabelBackground: Label = %DayLabelBackground
@onready var dayLabel: Label = %DayLabel
@onready var timeLabelBackground: Label = %TimeLabelBackground
@onready var timeLabel: Label = %TimeLabel
@onready var arrow: TextureRect = %Arrow


func setDaytime(day: int, hour: int, minute: int) -> void:
	dayLabel.text = "Day " + str(day + 1)
	dayLabelBackground.text = dayLabel.text
	
	timeLabel.text = _amfm_hour(hour) + ":" + _minute(minute) + " " + _am_pm(hour)
	timeLabelBackground.text = timeLabel.text
	
	if hour <= 12:
		arrow.rotation_degrees = _remap_rangef(hour, 0, 12, -90, 90)
	else:
		arrow.rotation_degrees = _remap_rangef(hour, 13, 23, 90, -90)


func _amfm_hour(hour:int) -> String:
	if hour == 0:
		return str(12)
	if hour > 12:
		return str(hour - 12)
	return str(hour)


func _minute(minute:int) -> String:
	if minute < 10:
		return "0" + str(minute)
	return str(minute)


func _am_pm(hour:int) -> String:
	if hour < 12:
		return "am"
	else:
		return "pm"


func _remap_rangef(input:float, minInput:float, maxInput:float, minOutput:float, maxOutput:float):
	return float(input - minInput) / float(maxInput - minInput) * float(maxOutput - minOutput) + minOutput
