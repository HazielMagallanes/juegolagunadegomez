extends InteractableObject
@export var toScene : String;
@export var toCoordinates : Vector2;


func _action() -> void:
	SignalBus.changeLevel.emit(toScene, toCoordinates);
	
