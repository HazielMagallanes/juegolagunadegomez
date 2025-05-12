class_name NPCBase;
extends CharacterBody2D;
#Attributes
var direction : Vector2i = Vector2i();
var chosenDirection : int = 0;
var pos = global_position;
var pointReached = {x = false, y = false};
var pathStage = 0;
var path: Array = [[]];
var stucked = false;
var data: Dictionary;
var dialogues: Dictionary;
var routine: Dictionary;
@onready var interactableArea : Area2D = $DialogInteractionArea;
@onready var Unstucker: Timer = $Unstucker; 
@onready var collisions: CollisionShape2D = $CollisionShape2D;
@onready var animationPlayer : AnimationPlayer = $AnimationPlayer;

var lastCollision : KinematicCollision2D;

func _ready() -> void:
	data = JSONLoader.loadJson("res://data/npc/" + str(get_meta("NPCId")) + ".json");
	#Handle non existant JSON.
	if data == {}:
		data = JSONLoader.loadJson("res://data/npc/default.json");
	dialogues = data.get("dialogues");
	routine = data.get("routine");
	set_meta("dialog", {
		"name": data.get("name", null),
		"text": dialogues.get("interacted").get("0").get("text")
		});
	path[0] = data.get("home_coordinates", null);
	SignalBus.connect("timeTick", Callable(self, "readRoutine"));
	print("NPC LOADED: ID=", get_meta("NPCId"));

#Getters and setters
func setPath(path: Array):
	self.path = path;

func pythagoreanDistance(a: Vector2, b: Vector2) -> float:
	return (b - a).length();

#Npc unstucker
func unstucker() -> void:
	if not stucked:
		Unstucker.stop();
		velocity = Vector2.ZERO
		collisions.disabled = false;
		return;
	#=========
	if lastCollision.get_collider() is Player or lastCollision.get_collider() is NPCBase :
		stucked = false;
		collisions.disabled = true;
		Unstucker.start(2);
	else:
		stucked = false;
		var colNormal = lastCollision.get_normal();
		var colPos = lastCollision.get_position();
		# Determine which direction to move around the obstcle
		if abs(colNormal.x) > abs(colNormal.y):  # Horizontal collision (left/right)
			if colPos.x > pos.x:
				#print_debug("HORIZONTAL_ [COL_POS: ", colPos, ", COL_NORMAL: ", colNormal, ", ", get_meta("NPCId"), ": [", pos,"]]");
				velocity = Vector2(0, -1);
				direction = Vector2i(0, -1);
			else:
				#print_debug("HORIZONTAL [COL_POS: ", colPos, ", COL_NORMAL: ", colNormal, ", ", get_meta("NPCId"), ": [", pos,"]]");
				velocity = Vector2(0, 1);
				direction = Vector2i(0, 1);
		else:  # Vertical collision (top/bottom)
			if colPos.y > pos.y:
				#print_debug("VERTICAL_ [COL_POS: ", colPos, ", COL_NORMAL: ", colNormal, ", ", get_meta("NPCId"), ": [", pos,"]]");
				velocity = Vector2(-1, 0);
				direction = Vector2i(-1, 0);
			else:
				#print_debug("VERTICAL [COL_POS: ", colPos, ", COL_NORMAL: ", colNormal, ", ", get_meta("NPCId"), ": [", pos,"]]");
				velocity = Vector2(1, 0);
				direction = Vector2i(1, 0);
		Unstucker.start(1.5);


func chooseDirection(x: int, y: int):
	var distanceToX = pythagoreanDistance(Vector2(pos.x, 0), Vector2(x, 0))
	if (distanceToX != 0 and distanceToX > pythagoreanDistance(Vector2(0, pos.y), Vector2(0, y))):
		#Go first to X axis
		chosenDirection = 1;
	else:
		chosenDirection = -1;

func move(delta: float):
	velocity = velocity.normalized();
	lastCollision = move_and_collide(velocity * 100 * delta);

func moveTo(x: int, y: int, delta: float):
	pos = global_position
	if not Unstucker.is_stopped():
		return;
	if pointReached.x and pointReached.y:
		velocity = Vector2.ZERO;
		pointReached.x = true;
		pointReached.y = true;
		chosenDirection = 0;
		return;
	move(delta);
	#Move if object interrupting or trasspass if NPC or Player interrupting
	if lastCollision != null:
		if (lastCollision.get_collider() is NPCBase or lastCollision.get_collider() is Player) and Unstucker.is_stopped(): 
			stucked = true;
			Unstucker.start(3);
		elif  abs(lastCollision.get_position().y - pos.y) <= 32 or abs(lastCollision.get_position().x - pos.x) <= 32:
			stucked = true;
			unstucker()
	else:
		match chosenDirection:
			0:
				chooseDirection(x, y);
			1:
				direction = Vector2(1 if x > pos.x else -1, 0);
				velocity = Vector2(direction.x, 0);
				if abs(pos.x - x) < 1: 
					chooseDirection(x, y);
					pointReached.x = true;
					return;
			-1:
				direction = Vector2(0, 1 if y > pos.y else -1);
				velocity = Vector2(0, direction.y);
				if abs(pos.y - y) < 1: 
					chooseDirection(x, y);
					pointReached.y = true;
					return;


func stopMoving():
	velocity = Vector2.ZERO;
	
	
func playMovingAnimation(animation : String):
		if(velocity != Vector2(0, 0)):
			animationPlayer.play(animation);
		else:
			animationPlayer.stop();

func update(delta: float):
	#Apply animations
	if direction == Vector2i(0, 1):
		playMovingAnimation("walk_fdown");
	if direction == Vector2i(0, -1):
		playMovingAnimation("walk_fup");
	if direction == Vector2i(1, 0):
		playMovingAnimation("walk_fright");
	if direction == Vector2i(-1, 0):
		playMovingAnimation("walk_fleft");

func readRoutine(day:int, hour:int, minute:int):
	if routine.get("default").has(str(hour)):
		setPath(routine.get("default").get(str(hour)).get("path"));

func _physics_process(delta: float):
	update(delta);
	#Follow Pathing
	if !stucked and !Unstucker.is_stopped():
		move(delta);
	else:
		if pointReached.x and pointReached.y:
			if pathStage != len(path) -1:
				pathStage +=1;
				pointReached.x = false;
				pointReached.y = false;
			else:
				stopMoving();
		else:
			if path[pathStage] != null: 
				moveTo(path[pathStage][0], path[pathStage][1], delta);

		

func _on_mouse_entered() -> void:
	print("Mouse entered");
func _on_mouse_exited() -> void:
	pass
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			$DialogInteractionArea._action();
