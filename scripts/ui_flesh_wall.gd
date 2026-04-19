extends Sprite2D

@export var follow_speed := 10.0
@export var snap_speed := 6.0
@export var max_offset := 200.0  # half-way threshold concept

var origin_x := 0.0

func _ready():
	origin_x = position.x


func _process(delta):
	if Controller.grabbed == "FleshWalls":
		var mouse_x = get_global_mouse_position().x
		var target_x = mouse_x

		# Convert to local offset from origin
		var offset = target_x - origin_x

		# If beyond allowed range, clamp behavior toward origin
		if abs(offset) > max_offset:
			target_x = lerp(target_x, origin_x, snap_speed * delta)

		# Smooth follow mouse on X only
		position.x = lerp(position.x, target_x, follow_speed * delta)
	else:
		# optional: return to origin when not grabbed
		position.x = lerp(position.x, origin_x, snap_speed * delta)
