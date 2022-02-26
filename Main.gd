extends Node2D

var last_player_pos;
var follow_player = false;
var screen_size;
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport().get_visible_rect().size
	last_player_pos = $Player.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if follow_player:
		update_camera()
	last_player_pos = $Player.position

func update_camera():
	var canvas_transform = get_viewport().get_canvas_transform()
	var player_offset = last_player_pos - $Player.position
	canvas_transform[2] += player_offset
	get_viewport().set_canvas_transform(canvas_transform)
	"""
	var canvas_transform = get_viewport().get_canvas_transform()
	# For some reason canvas_transform x is always negative to player's x so we add its 
	# Negation (We don't substruct for clarity of code)
	if abs(((screen_size.x/2) + -canvas_transform[2].x) - $Player.position.x) > 100:
		var player_offset = last_player_pos.x - $Player.position.x
		canvas_transform[2] += Vector2(player_offset, 0)
	var threshold;
	if last_player_pos.y < $Player.position.y:
		threshold = 300;
	else:
		threshold = 250;
	if abs(((screen_size.y/2) + -canvas_transform[2].y) - $Player.position.y) > threshold:
		var player_offset = last_player_pos.y - $Player.position.y
		canvas_transform[2] += Vector2(0, player_offset)
	get_viewport().set_canvas_transform(canvas_transform)
	"""


func _on_camera_controller_player_entered():
	follow_player = true;
