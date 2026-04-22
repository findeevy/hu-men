extends CharacterBody2D

var wanderTimer = 1.0
var modeTimer = 10.0

@export var bounds_min := Vector2(60, 300)
@export var bounds_max := Vector2(660, 520)

var speed := 100

# Tracking the currently targeted food
var current_target_key: String = ""
var current_target_node: Node2D = null

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
		# Ensure we have a valid target
		if current_target_node == null or not is_instance_valid(current_target_node):
			find_new_target()
		
		if current_target_node:
			var dist = global_position.distance_to(current_target_node.global_position)
			if dist < 10:
				start_grabbing()
			else:
				var dir = (current_target_node.global_position - global_position).normalized()
				velocity = dir * speed
		else:
			# No food left
			Controller.hu_type = "wander"
			current_target_key = ""
			current_target_node = null

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


func find_new_target() -> void:
	var closest_key = ""
	var closest_node: Node2D = null
	var closest_dist_sq = INF
	
	for food_name in Controller.food_dict.keys():
		var entry = Controller.food_dict[food_name]
		var food_node = entry["node"]
		
		# Skip if node is invalid (safety cleanup)
		if not is_instance_valid(food_node):
			Controller.food_dict.erase(food_name)
			continue
		
		# Optional: only target "alive" food
		if entry["status"] != "alive":
			continue
		
		var d_sq = global_position.distance_squared_to(food_node.global_position)
		if d_sq < closest_dist_sq:
			closest_dist_sq = d_sq
			closest_key = food_name
			closest_node = food_node
	
	current_target_key = closest_key
	current_target_node = closest_node


func start_grabbing() -> void:
	Controller.hu_type = "grab"
	modeTimer = 30.0
	# The actual consumption will happen when the arm finishes rotating


# Called by the arm when a full rotation completes
func _on_grab_complete() -> void:
	if current_target_node and is_instance_valid(current_target_node):
		# Change status to "eaten" (or just remove)
		if current_target_key in Controller.food_dict:
			Controller.food_dict[current_target_key]["status"] = "eaten"
		# Tell the food to delete itself
		if current_target_node.has_method("get_eaten"):
			current_target_node.get_eaten()
	
	# Clear target
	current_target_key = ""
	current_target_node = null
