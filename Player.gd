extends Node2D

var attack_is_on = false;

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
			if body.has_method("hit_by_player"):
				body.hit_by_player()
	

func _on_attack_is_on_timer_timeout():
	attack_is_on = false;


func _on_player_body_attack_finished():
	$AttackIsOnTimer.start();
	attack_is_on = true;
