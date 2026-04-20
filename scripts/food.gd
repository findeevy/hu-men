extends Sprite2D

@export var bounds_min := Vector2(60, 300)
@export var bounds_max := Vector2(660, 520)

@export var duration := 1.0
var elapsed := 0.0

func _ready():
	scale = Vector2(0.1, 0.1)

func _process(delta):
	if elapsed < duration:
		elapsed += delta
		var t = clamp(elapsed / duration, 0.0, 1.0)
		scale = Vector2.ONE * lerp(0.1, 1.0, t)
	elif Controller.grabbed == get_child(0).name:
		z_index = 10
		var mouse_pos = get_global_mouse_position()
		position = mouse_pos - Vector2(1, 10)
		position.x = clamp(position.x, bounds_min.x, bounds_max.x)
		position.y = clamp(position.y, bounds_min.y, bounds_max.y)
	else:
		z_index = 0
