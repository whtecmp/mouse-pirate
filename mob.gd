extends CharacterBody2D

const SPEED = 250.0
const JUMP_VELOCITY = -400.0

enum {TOO_CLOSE_LEFT, TOO_CLOSE_RIGHT, TOO_FAR, LEFT, RIGHT }

var wants_jump = false;
var wants_attack = false;
var is_attacking = false;
var return_attack = false;
var attack_idle = false;
var can_idle = true;
var walk = false;
var direction = 0;
var play_animation;
var stop_animation;
var flip;
var look_direction = RIGHT;
var attack_is_on = false;
var whoami;


# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func assess_relative_position_to_objective(objective, min_distance_threshold, max_distance_threshold):
	if not objective:
		return TOO_FAR
	var distance_from_object = global_position.x - objective.global_position.x
	if min_distance_threshold < distance_from_object and distance_from_object < max_distance_threshold:
		return LEFT;
	elif -min_distance_threshold > distance_from_object and distance_from_object > -max_distance_threshold:
		return RIGHT;
	elif -min_distance_threshold < distance_from_object and distance_from_object < 0:
		return TOO_CLOSE_LEFT;
	elif 0 < distance_from_object and distance_from_object < min_distance_threshold:
		return TOO_CLOSE_RIGHT;
	else:
		return TOO_FAR;

func manage_attack():
	if attack_is_on:
		var in_range_bodies;
		if look_direction == RIGHT:
			in_range_bodies = get_node("../Detectors/AttackDetectorRight").get_overlapping_bodies()
		elif look_direction == LEFT:
			in_range_bodies = get_node("../Detectors/AttackDetectorLeft").get_overlapping_bodies()
		for body in in_range_bodies:
			if body.has_method("hit_by"):
				body.hit_by(whoami)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var relative_position_to_objective = assess_relative_position_to_objective(get_tree().get_root().get_node("Main/Player/PlayerBody"), 120, 1000);
	{ # switch case relative_position_to_objective
		LEFT: func (_self):
			_self.walk = true;
			_self.direction = -1,
		RIGHT: func (_self):
			_self.walk = true;
			_self.direction = 1,
		TOO_FAR: func (_self):
			_self.walk = false;,
		TOO_CLOSE_LEFT: func (_self):
			_self.direction = -1;
			_self.walk = false;
			_self.wants_attack = true;,
		TOO_CLOSE_RIGHT: func (_self):
			_self.direction = 1;
			_self.walk = false;
			_self.wants_attack = true;
	}[relative_position_to_objective].call(self);

	if wants_attack and not is_attacking and not attack_idle:
		wants_attack = false;
		play_animation.call("Attack");
		is_attacking = true;
		can_idle = false;
		attack_idle = true;
		$AttackTimer.start()

	# Handle Jump.
	if wants_jump and is_on_floor() and not is_attacking:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if walk and not is_attacking:
		velocity.x = direction * SPEED
		play_animation.call("Run")
	else:
		if can_idle:
			play_animation.call("Idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if walk and not is_attacking and direction > 0:
		flip.call(false);
	elif walk and not is_attacking and direction < 0:
		flip.call(true);

	manage_attack()

	if velocity.x < 0:
		look_direction = LEFT;
	elif velocity.x > 0: 
		look_direction = RIGHT;
	var last_position = position;
	move_and_slide();
	var mob = get_node("..");
	mob.get_node("Detectors").position += position - last_position;


func attack_finished():
	if return_attack:
		play_animation.call("Idle")
		can_idle = true;
		return_attack = false;
		is_attacking = false;
	else:
		stop_animation.call()
		play_animation.call("Attack", 1, true)
		return_attack = true;
		$AttackIsOnTimer.start();
		attack_is_on = true;


func hit_by(who):
	get_node("..").hit_by(who);

func _on_attack_timer_timeout():
	attack_idle = false;

func _on_attack_is_on_timer_timeout():
	attack_is_on = false;
