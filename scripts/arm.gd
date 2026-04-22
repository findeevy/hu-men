extends Sprite2D

@export var rotation_speed = 360
var rotated_amount = 0

func _process(delta):
	if Controller.hu_type == "grab":
		var step = rotation_speed * delta
		rotation_degrees += step
		rotated_amount += step

		if abs(rotated_amount) >= 360:
			rotation_degrees -= rotated_amount
			rotated_amount = 0
			Controller.hu_type = "wander"
