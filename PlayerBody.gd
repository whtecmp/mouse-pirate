extends CharacterBody2D

signal look_up
signal look_down
signal look_reg
signal attack_finished

const SPEED = 350.0
const INITIAL_JUMP_VELOCITY = -200.0
const MAX_JUMP_VELOCITY = -300.0
const JUMP_VELOCITY_INTERVAL = -33;

var can_idle = true;
var return_attack = false;
var is_attacking = false;
var is_fliped = false;
var looking = false;
var looked = false;
var start_looking_time;
var jumping = false;

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_pressed("a") and jumping and abs(velocity.y) < abs(MAX_JUMP_VELOCITY):
		velocity.y += JUMP_VELOCITY_INTERVAL;
	else:
		jumping = false;
	if Input.is_action_just_pressed("a") and is_on_floor():
		velocity.y = INITIAL_JUMP_VELOCITY
		jumping = true;
	
	
	if Input.is_action_just_pressed("s") and not is_attacking:
		$AnimatedSprite.play("Attack")
		can_idle = false;
		is_attacking = true;

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right");
	if direction and not is_attacking:
		velocity.x = direction * SPEED
		$AnimatedSprite.play("Run")
		if direction < 0:
			is_fliped = true;
		else:
			is_fliped = false;
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if can_idle:
			$AnimatedSprite.play("Idle") 
	$AnimatedSprite.flip_h = is_fliped;
	var look = Input.get_axis("ui_up", "ui_down");
	if look:
		if looking:
			var looking_time = Time.get_time_dict_from_system().second - start_looking_time;
			if looking_time >= 1:
				looked = true;
				if look < 0:
					emit_signal("look_up")
				else:
					emit_signal("look_down")
		else:
			start_looking_time = Time.get_time_dict_from_system().second;
			looking = true;
	elif looked:
		looked = false;
		looking = false;
		emit_signal("look_reg")
	elif looking:
		looking = false;
	var last_position = position;
	move_and_slide();
	var player = get_node("..");
	player.get_node("Detectors").position += position - last_position;


func _on_animated_sprite_animation_finished():
	if $AnimatedSprite.animation == "Attack":
		if return_attack:
			$AnimatedSprite.play("Idle")
			can_idle = true;
			return_attack = false;
			is_attacking = false;
		else:
			$AnimatedSprite.stop()
			$AnimatedSprite.play("Attack", true)
			return_attack = true;
			emit_signal("attack_finished")

func hit_by(who_hit):
	get_node("..").hit_by(who_hit);
