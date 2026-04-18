extends Sprite2D

var origin: Vector2
var timer := 0.0
var next_time := 0.0

func _ready() -> void:
	randomize()
	origin = position
	next_time = randf_range(0.3, 1.0)

func _physics_process(delta: float) -> void:
	timer += delta

	if timer >= next_time:
		timer = 0.0
		next_time = randf_range(0.3, 1.0)

		var step = Vector2(
			randi_range(-1, 1),
			randi_range(-1, 1)
		)

		position += step
		
		position.x = clamp(position.x, origin.x - 5.0, origin.x + 5.0)
		position.y = clamp(position.y, origin.y - 5.0, origin.y + 5.0)
