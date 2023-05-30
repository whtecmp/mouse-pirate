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
	$Mob.play_animation = func(anim, custom_speed = 1.0, backwards = false):
		custom_speed = custom_speed * (-1 if backwards else 1);
		_self.get_node("Mob/MouseBody").play(anim, custom_speed, backwards);
		_self.get_node("Mob/MouseWeaponHand").play(anim, custom_speed, backwards);
	$Mob.flip = flip;
	$Mob.whoami = "enemy_mouse"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func hit_by(who):
	if who == "player":
		queue_free();

func _on_mouse_body_animation_finished():
	if $Mob/MouseBody.animation == "Attack":
		$Mob.attack_finished();
