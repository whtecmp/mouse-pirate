extends CharacterBody2D

var control_scheme = "Keyboard";
var control_scheme_to_key_to_input = {
	"Keyboard": {
		"ui_left": "left",
		"ui_right": "right",
		"ui_up": "up",
		"ui_down": "down",
		"z": "jump",
		"x": "attack",
	}
}

var input_to_function = {
	"left": null
}

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var can_idle = true;
var return_attack = false;
var is_attacking = false;
var is_fliped = false;

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		motion_velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("a") and is_on_floor():
		motion_velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("s") and not is_attacking:
		$AnimatedSprite.play("Attack")
		can_idle = false;
		is_attacking = true;

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction and not is_attacking:
		motion_velocity.x = direction * SPEED
		$AnimatedSprite.play("Run")
		if direction < 0:
			is_fliped = true;
		else:
			is_fliped = false;
	else:
		motion_velocity.x = move_toward(motion_velocity.x, 0, SPEED)
		if can_idle:
			$AnimatedSprite.play("Idle") 
	$AnimatedSprite.flip_h = is_fliped;
	move_and_slide()

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
