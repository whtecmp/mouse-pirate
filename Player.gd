extends Node2D

signal player_change_hit_points(new_value)

var attack_is_on = false;
var hits = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if attack_is_on:
		var in_range_bodies;
		if not $PlayerBody.is_fliped:
			in_range_bodies = $Detectors/AttackDetectorRight.get_overlapping_bodies()
		else:
			in_range_bodies = $Detectors/AttackDetectorLeft.get_overlapping_bodies()
		for body in in_range_bodies:
			if body.has_method("hit_by"):
				body.hit_by("player")
	

func _on_attack_is_on_timer_timeout():
	attack_is_on = false;


func _on_player_body_attack_finished():
	$AttackIsOnTimer.start();
	attack_is_on = true;

func hit_by(who):
	if who == "enemy_mouse":
		hits += 1
		emit_signal("player_change_hit_points", hits)
