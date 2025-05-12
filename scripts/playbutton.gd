extends Button


func _on_button_up() -> void:
	get_tree().paused = false
	get_parent().get_parent().get_parent().get_parent().get_node("./Clock/DayNightCycleUI").visible = true;
	get_parent().get_parent().get_parent().get_parent().get_node("./TimeVFX").visible = true;
	SignalBus.changeLevel.emit("res://scenes/World.tscn", Vector2(357,759));
