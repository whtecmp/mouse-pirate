extends Area2D

signal player_entered;
signal player_exited;
# Called when the node enters the scene tree for the first time.

var last_view_position;
func _ready():
	last_view_position = -get_viewport().get_canvas_transform()[2];

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var view_position = -get_viewport().get_canvas_transform()[2]
	position += view_position - last_view_position
	last_view_position = view_position

func _on_camera_controller_area_entered(area):
	if area.get_name() == "PlayerArea":
		emit_signal("player_entered")


func _on_camera_controller_area_exited(area):
	if area.get_name() == "PlayerArea":
		emit_signal("player_exited")
