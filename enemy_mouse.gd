extends Node2D

func flip(to_flip):
	$Mob/MouseBody.flip_h = to_flip;
	$Mob/MouseWeaponHand.flip_h = to_flip;

# Called when the node enters the scene tree for the first time.
func _ready():
	var _self = self;
	$Mob.play_animation = func(anim):
		_self.get_node("Mob/MouseBody").play(anim);
		_self.get_node("Mob/MouseWeaponHand").play(anim);
	$Mob.flip = flip;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
