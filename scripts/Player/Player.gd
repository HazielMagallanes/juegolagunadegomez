class_name Player;
extends CharacterBody2D

#Attributes
var direction : Vector2i = Vector2i();
@onready var animationPlayer : AnimationPlayer = $AnimationPlayer;


func readInput(delta: float):
	if Input.is_action_pressed("up"):
		velocity.y -= 1;
		direction = Vector2i(0, -1);
	if Input.is_action_pressed("down"):
		velocity.y += 1;
		direction = Vector2i(0, 1);
	if Input.is_action_pressed("left"):
		velocity.x -= 1;
		direction = Vector2i(-1, 0);
	if Input.is_action_pressed("right"):
		velocity.x += 1;
		direction = Vector2i(1, 0);
	#Deassign velocities.
	if Input.is_action_just_released("down") or Input.is_action_just_released("up"):
		velocity.y = 0;
	if Input.is_action_just_released("left") or Input.is_action_just_released("right"):
		velocity.x = 0;
	
	velocity = velocity.normalized();
	move_and_collide(velocity * 200 * delta);

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

func _physics_process(delta: float):
	readInput(delta)
	update(delta)
