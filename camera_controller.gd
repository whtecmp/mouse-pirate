extends Area2D

signal player_entered;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_camera_controller_area_entered(area):
	if area.get_name() == "PlayerArea":
		emit_signal("player_entered")
