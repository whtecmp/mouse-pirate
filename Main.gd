extends Node2D

const LOOK_DISTANCE = -60;

var last_player_pos;
var follow_player = Vector2(0, 0);
var screen_size;
var look_vec = Vector2(0, 0);
var look = false;
var looked = false;
var stoped_looking = false;
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport().get_visible_rect().size
	last_player_pos = $Player/PlayerBody.position
	$Player/PlayerBody.look_down.connect(_on_player_look_down);
	$Player/PlayerBody.look_reg.connect(_on_player_look_reg);
	$Player/PlayerBody.look_up.connect(_on_player_look_up);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_camera()
	last_player_pos = $Player/PlayerBody.position

func update_camera():
	var canvas_transform = get_viewport().get_canvas_transform()
	var player_offset = last_player_pos - $Player/PlayerBody.position
	player_offset.x *= follow_player.x
	player_offset.y *= follow_player.y
	player_offset *= 2;
	canvas_transform[2] += player_offset
	if look and not looked:
		canvas_transform[2] += look_vec * LOOK_DISTANCE;
		looked = true;
	elif stoped_looking:
		canvas_transform[2] -= look_vec * LOOK_DISTANCE;
		look_vec = Vector2(0, 0);
		stoped_looking = false;
	get_viewport().set_canvas_transform(canvas_transform)

func _on_camera_controller_player_entered_x():
	follow_player += Vector2(1, 0);

func _on_camera_controller_player_exited_x():
	follow_player -= Vector2(1, 0);

func _on_camera_controller_player_entered_y():
	follow_player += Vector2(0, 1);

func _on_camera_controller_player_exited_y():
	follow_player -= Vector2(0, 1);

func _on_player_look_down():
	look_vec = Vector2(0, 1);
	look = true;

func _on_player_look_reg():
	look = false;
	looked = false;
	stoped_looking = true;

func _on_player_look_up():
	look_vec = Vector2(0, -1)
	look = true;
