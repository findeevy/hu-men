extends Sprite2D

@export var follow_speed := 10.0
@export var snap_speed := 8.0

var origin_x := 0.0
var snap_target := 0.0
var drag_offset := 0.0
var dragging := false

func _ready():
	origin_x = position.x
	snap_target = origin_x


func _physics_process(delta: float) -> void:
	if Controller.grabbed == "FleshWalls":
		if !dragging:
			dragging = true
			drag_offset = position.x - get_global_mouse_position().x
		
		var mouse_x = get_global_mouse_position().x
		position.x = mouse_x + drag_offset

	else:
		if dragging:
			dragging = false
			
			# Decide snap target based on midpoint between 622 and 0
			var midpoint = origin_x / 1.5
			
			if position.x > midpoint:
				snap_target = origin_x
			else:
				snap_target = 150     # 0
		
		position.x = lerp(position.x, snap_target, snap_speed * delta)
