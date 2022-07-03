extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var value = str(get_node("..").name) + '-' + str(name) + ': ' + str(get_overlapping_areas())
	# print (value)


func _on_attack_detector_body_entered(body):
	# emit_signal("object_entered_attack_range", get_node("."), body)
	pass
