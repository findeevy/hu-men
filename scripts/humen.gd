extends Node2D

var wanderTimer = 1.0
var modeTimer = 10.0

@export var bounds_min := Vector2(60, 300)
@export var bounds_max := Vector2(660, 520)
func _ready() -> void:
	add_to_group("grabbable")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
func modeTracker(delta: float) -> void:
	modeTimer -= delta
	if modeTimer <= 0:
		Controller.hu_type = Controller.hu_types[randi_range(0, 1)]
		modeTimer = randf_range(15, 30)

func _physics_process(delta: float) -> void:
	modeTracker(delta)
	print(Controller.grabbed)
	if Controller.grabbed == self:
		var mouse_pos = get_global_mouse_position()
		
		position = mouse_pos  - Vector2(0,-160)
		
		# clamp to bounds
		position.x = clamp(position.x, bounds_min.x, bounds_max.x)
		position.y = clamp(position.y, bounds_min.y, bounds_max.y)
	elif Controller.hu_type == "chase":
		var closest_food = null
		var closest_dist = INF
		
		for key in Controller.hu_stuff.keys():
			if "Food" in key:
				var food = Controller.hu_stuff[key]
				if food: # make sure it exists
					var dist = position.distance_to(food.position)
					if dist < closest_dist:
						closest_dist = dist
						closest_food = food
		
		if closest_food:
			var dir = (closest_food.position - position).normalized()
			var speed = 100 # tweak this
			position += dir * speed * delta
	elif Controller.hu_type == "wander":

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
			wanderTimer = randf_range(2.0, 4.0)
			Controller.hu_mode = "up"
		if position.y < bounds_min.y:
			wanderTimer = randf_range(2.0, 4.0)
			Controller.hu_mode = "down"
		if position.x < bounds_min.x:
			wanderTimer = randf_range(2.0, 4.0)
			Controller.hu_mode = "right"
		if position.x > bounds_max.x:
			wanderTimer = randf_range(2.0, 4.0)
			Controller.hu_mode = "left"

		wanderTimer -= delta
		if wanderTimer < 0.0:
			Controller.hu_mode = Controller.hu_roam[randi_range(0, 4)]
			wanderTimer = randf_range(0.5, 2.0)
