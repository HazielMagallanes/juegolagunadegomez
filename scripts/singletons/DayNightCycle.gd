extends CanvasModulate

const MINUTES_PER_DAY = 1440
const MINUTES_PER_HOUR = 60
const INGAME_TO_REAL_MINUTE_DURATION = (2 * PI) / MINUTES_PER_DAY


@export var gradientTexture: GradientTexture1D;
@export var INGAME_SPEED: float = 1.0;
@export var INITIAL_HOUR = 12:
	set(hour):
		INITIAL_HOUR = hour;
		time = INGAME_TO_REAL_MINUTE_DURATION * INITIAL_HOUR * MINUTES_PER_DAY;

var time : float = 0.0
var pastMinute: int = -1;

func _ready() -> void:
	time = INGAME_TO_REAL_MINUTE_DURATION * INITIAL_HOUR * MINUTES_PER_HOUR;

func _process(delta: float) -> void:
	time += delta * INGAME_TO_REAL_MINUTE_DURATION * INGAME_SPEED;
	var value = (sin(time - PI / 2.0) + 1.0) / 2.0
	self.color = gradientTexture.gradient.sample(value);
	_recalculateTime();
	
func _recalculateTime() -> void:
	var totalMinutes = int(time / INGAME_TO_REAL_MINUTE_DURATION);
	var day = int(totalMinutes / MINUTES_PER_DAY)
	var currentDayMinutes = totalMinutes % MINUTES_PER_DAY
	var hour = int(currentDayMinutes / MINUTES_PER_HOUR)
	var minute = int(currentDayMinutes % MINUTES_PER_HOUR)	
	if pastMinute != minute:
		pastMinute = minute
		SignalBus.timeTick.emit(day, hour, minute)
