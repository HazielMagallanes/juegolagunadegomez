extends Control

func _ready() -> void:
	get_tree().paused = true;
	get_parent().get_parent().get_node("./Clock/DayNightCycleUI").visible = false;
	get_parent().get_parent().get_node("./TimeVFX").visible = false;
