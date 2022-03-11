extends CharacterBody2D

const SPEED = 250.0
const JUMP_VELOCITY = -400.0

enum {TOO_CLOSE, TOO_FAR, LEFT, RIGHT }

var wants_jump = false;
var wants_attack = false;
var walk_direction = 0;
var play_animation;
var flip;


# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func assess_relative_position_to_objective(objective, min_distance_threshold, max_distance_threshold):
	var distance_from_object = global_position.x - objective.global_position.x
	if min_distance_threshold < distance_from_object and distance_from_object < max_distance_threshold:
		return LEFT;
	elif -min_distance_threshold > distance_from_object and distance_from_object > -max_distance_threshold:
		return RIGHT;
	elif -min_distance_threshold < distance_from_object and distance_from_object < min_distance_threshold:
		return TOO_CLOSE;
	else:
		return TOO_FAR;

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		motion_velocity.y += gravity * delta
	
	var relative_position_to_objective = assess_relative_position_to_objective(get_tree().get_root().get_node("Main/Player"), 150, 300);
	{
		LEFT: func (_self):
			_self.walk_direction = -1;,
		RIGHT: func (_self):
			_self.walk_direction = 1;,
		TOO_CLOSE: func (_self):
			_self.walk_direction = 0;,
		TOO_FAR: func (_self):
			_self.walk_direction = 0;
			_self.wants_attack = true;
	}[relative_position_to_objective].call(self);

	# Handle Jump.
	if wants_jump and is_on_floor():
		motion_velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if walk_direction:
		motion_velocity.x = walk_direction * SPEED
		play_animation.call("Run")
	else:
		play_animation.call("Idle")
		motion_velocity.x = move_toward(motion_velocity.x, 0, SPEED)
	if walk_direction > 0:
		flip.call(false);
	elif walk_direction < 0:
		flip.call(true);

	move_and_slide()
