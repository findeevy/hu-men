extends Node

var last_mouse_pos = Vector2()

func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()

	if mouse_pos != last_mouse_pos:
		Controller.INTRO_PROGRESS_AMOUNT += delta

	last_mouse_pos = mouse_pos
