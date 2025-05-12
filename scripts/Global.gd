extends Window

@onready var musicPlayer = $MusicPlayer;
@onready var clockLayer = $Clock;
@onready var clockUI = $Clock/DayNightCycleUI;
@onready var clock = $TimeVFX;
func _ready() -> void:
	SignalBus.connect("changeLevel", Callable(self, "on_changeLevel"));
	clockLayer.visible = true;
	clock.visible = true;
	SignalBus.timeTick.connect(clockUI.setDaytime);

func on_changeLevel(path: String, spawn: Vector2):
	clock.visible = true;
	$Level.remove_child($Level/Level)
	$Level.add_child(load(path).instantiate());
	if $Level/Level.has_node("Player"):
		$Level/Level/Player.global_position = spawn;
	if $Level/Level.get_meta("isInterior", false):
		clock.visible = false;
func _process(delta: float) -> void:
	if !musicPlayer.playing: musicPlayer.play();
