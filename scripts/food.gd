extends Sprite2D

@export var bounds_min := Vector2(60, 300)
@export var bounds_max := Vector2(660, 520)

@export var duration := 1.0
var elapsed := 0.0
var touch = false

func _ready():
	add_to_group("grabbable")
	add_to_group("food")
	
	# Generate a unique name
	var unique_name = "Food" + name + str(Controller.stuff_count)
	name = unique_name
	Controller.stuff_count += 1
	
	# Register in controller's food_dict with metadata
	Controller.food_dict[unique_name] = {
		"node": self,
		"status": "alive"
	}
	
	scale = Vector2(0.1, 0.1)

func _process(delta):
	if elapsed < duration:
		elapsed += delta
		var t = clamp(elapsed / duration, 0.0, 1.0)
		scale = Vector2.ONE * lerp(0.1, 1.0, t)
	elif Controller.grabbed == self:
		touch = true
		z_index = 15
		var mouse_pos = get_global_mouse_position()
		position = mouse_pos - Vector2(1, 10)
		position.x = clamp(position.x, bounds_min.x, bounds_max.x)
		position.y = clamp(position.y, bounds_min.y, bounds_max.y)
	elif touch:
		z_index = 0

# Called when the human eats/grabs this food
func get_eaten():
	# Remove from dictionary
	Controller.food_dict.erase(name)
	queue_free()
