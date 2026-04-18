extends Node3D

@export var base_scale = 20.25
@export var amplitude = 0.25
var time_passed = 0.0
@export var pulse_speed = 2.0

func _process(delta):
	time_passed += delta * pulse_speed
	var scale_value = base_scale + sin(time_passed) * amplitude
	scale = Vector3.ONE * scale_value
