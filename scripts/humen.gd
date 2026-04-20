extends Node2D

var timer = 1.0

@export var bounds_min := Vector2(60, 300)
@export var bounds_max := Vector2(660, 520)
func _ready() -> void:
	add_to_group("grabbable")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _physics_process(delta: float) -> void:
	print(Controller.grabbed)
	if Controller.grabbed == self:
		var mouse_pos = get_global_mouse_position()
		
		position = mouse_pos  - Vector2(0,-160)
		
		# clamp to bounds
		position.x = clamp(position.x, bounds_min.x, bounds_max.x)
		position.y = clamp(position.y, bounds_min.y, bounds_max.y)
		
		return
		
	if Controller.hu_type == "wander":

		if Controller.hu_mode == "right":
			position.x += 1
		elif Controller.hu_mode == "left":
			position.x -= 1
		elif Controller.hu_mode == "up":
			position.y -= 1
		elif Controller.hu_mode == "down":
			position.y += 1

		# bounds
		if position.y > bounds_max.y:
			timer = randf_range(2.0, 4.0)
			Controller.hu_mode = "up"
		if position.y < bounds_min.y:
			timer = randf_range(2.0, 4.0)
			Controller.hu_mode = "down"
		if position.x < bounds_min.x:
			timer = randf_range(2.0, 4.0)
			Controller.hu_mode = "right"
		if position.x > bounds_max.x:
			timer = randf_range(2.0, 4.0)
			Controller.hu_mode = "left"

		timer -= delta
		if timer < 0.0:
			Controller.hu_mode = Controller.hu_roam[randi_range(0, 4)]
			timer = randf_range(0.5, 2.0)
