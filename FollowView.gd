extends Node2D

var last_view_position;
func _ready():
	last_view_position = -get_viewport().get_canvas_transform()[2];

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var view_position = -get_viewport().get_canvas_transform()[2]
	position += view_position - last_view_position
	last_view_position = view_position
