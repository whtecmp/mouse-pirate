extends Node2D

func flip(to_flip):
	$Mob/MouseBody.flip_h = to_flip;
	$Mob/MouseWeaponHand.flip_h = to_flip;

# Called when the node enters the scene tree for the first time.
func _ready():
	var _self = self;
	$Mob.stop_animation = func():
		_self.get_node("Mob/MouseBody").stop();
		_self.get_node("Mob/MouseWeaponHand").stop();
	$Mob.play_animation = func(anim, backwards = false):
		_self.get_node("Mob/MouseBody").play(anim, backwards);
		_self.get_node("Mob/MouseWeaponHand").play(anim, backwards);
	$Mob.flip = flip;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_body_animation_finished():
	if $Mob/MouseBody.animation == "Attack":
		$Mob.attack_finished();
