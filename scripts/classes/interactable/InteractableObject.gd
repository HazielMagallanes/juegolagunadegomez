class_name InteractableObject

extends Area2D

func _on_area_entered(area: Area2D) -> void:
	set_meta("areaActive", true);

func _on_area_exited(area: Area2D) -> void:
	set_meta("areaActive", false);

func _input(event: InputEvent) -> void:
	if event.is_action_released("interact", false) and self.get_meta("areaActive"):
		_action()

func _action() -> void:
	pass
	
