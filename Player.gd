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

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		motion_velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		motion_velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		motion_velocity.x = direction * SPEED
		$AnimatedSprite.play("Run")
		if direction < 0:
			$AnimatedSprite.flip_h = true;
		else:
			$AnimatedSprite.play("Run")
			$AnimatedSprite.flip_h = false;
	else:
		motion_velocity.x = move_toward(motion_velocity.x, 0, SPEED)
		$AnimatedSprite.play("Idle")
	move_and_slide()
