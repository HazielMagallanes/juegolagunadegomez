extends InteractableObject

func _action() -> void:
	var data: Dictionary = self.get_parent().get_meta("dialog", {
		"name": null,
		"text": ["No se encontro dialogo."]
		})
	SignalBus.displayDialog.emit(data.get("text"), data.get("name"));
