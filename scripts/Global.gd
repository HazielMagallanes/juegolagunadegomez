extends Node

@onready var musicPlayer = $MusicPlayer;
@onready var clockLayer = $Clock;
@onready var clockUI = $Clock/DayNightCycleUI;
@onready var clock = $TimeVFX;
func _ready() -> void:
	SignalBus.connect("changeLevel", Callable(self, "on_changeLevel"));
func on_changeLevel(path: String, spawn: Vector2):
	$Level.remove_child($Level/Level)
	$Level.add_child(load(path).instantiate());
	if $Level/Level.has_node("Player"):
		$Level/Level/Player.global_position = spawn;
func _process(delta: float) -> void:
	if !musicPlayer.playing: musicPlayer.play();
