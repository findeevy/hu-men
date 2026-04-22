extends CharacterBody2D

var wanderTimer = 1.0
var modeTimer = 10.0

@export var bounds_min := Vector2(60, 300)
@export var bounds_max := Vector2(660, 520)

var speed := 100

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

	if Controller.grabbed == self:
		var mouse_pos = get_global_mouse_position()
		var target = mouse_pos - Vector2(0, -160)

		# Move toward mouse using velocity (keeps collision)
		velocity = (target - global_position) * 10
	else:
		handle_ai(delta)

	move_and_slide()
	
	global_position.x = clamp(global_position.x, bounds_min.x, bounds_max.x)
	global_position.y = clamp(global_position.y, bounds_min.y, bounds_max.y)


func handle_ai(delta: float) -> void:
	if Controller.hu_type == "grab":
		velocity = Vector2.ZERO
		
	elif Controller.hu_type == "chase":
		var closest_food = null
		var closest_dist = INF
		
		for key in Controller.hu_stuff.keys():
			if "Food" in key:
				var food = Controller.hu_stuff[key]
				if food:
					var dist = global_position.distance_to(food.global_position)
					if dist < 10:
						print("FOUND")
						Controller.hu_type = "grab"
						modeTimer = 30
						break
					elif dist < closest_dist:
						closest_dist = dist
						closest_food = food
		
		if closest_food:
			var dir = (closest_food.global_position - global_position).normalized()
			velocity = dir * speed
		elif Controller.hu_type != "grab":
			Controller.hu_type = "wander"

	elif Controller.hu_type == "wander":
		var dir := Vector2.ZERO

		if Controller.hu_mode == "right":
			dir.x += 1
		elif Controller.hu_mode == "left":
			dir.x -= 1
		elif Controller.hu_mode == "up":
			dir.y -= 1
		elif Controller.hu_mode == "down":
			dir.y += 1

		velocity = dir.normalized() * speed

		# bounds reaction
		if global_position.y >= bounds_max.y:
			Controller.hu_mode = "up"
		elif global_position.y <= bounds_min.y:
			Controller.hu_mode = "down"
		elif global_position.x <= bounds_min.x:
			Controller.hu_mode = "right"
		elif global_position.x >= bounds_max.x:
			Controller.hu_mode = "left"

		wanderTimer -= delta
		if wanderTimer < 0.0:
			Controller.hu_mode = Controller.hu_roam[randi_range(0, 4)]
			wanderTimer = randf_range(0.5, 2.0)
