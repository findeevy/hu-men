extends Sprite2D

@export var max_angle_degrees := 15.0
@export var rotation_speed := 3.0

var time_passed := 0.0
var origin_rotation := 0.0

func _ready():
	origin_rotation = rotation

func _process(delta):
	if Controller.hu_mode == "still":
		rotation = lerp_angle(rotation, origin_rotation, 0.1)
		return

	time_passed += delta * rotation_speed
	
	var offset = sin(time_passed) * deg_to_rad(max_angle_degrees)
	rotation = origin_rotation + offset
