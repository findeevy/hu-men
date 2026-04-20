extends Area2D

@export var prefab_path: String = "res://objects/food.tscn"
@export var normal_texture: Texture2D = preload("res://textures/ui/vending_button_up.png")
@export var pressed_texture: Texture2D = preload("res://textures/ui/vending_button_down.png")

var prefab_scene: PackedScene = null

var out = true

func _ready():
	
	# Load the prefab scene from file
	prefab_scene = load(prefab_path)  # Load the scene from the file path

	# Check if the scene loaded correctly
	if prefab_scene == null:
		print("Failed to load prefab scene!")
	else:
		print("Prefab loaded successfully!")

func _physics_process(delta: float) -> void:
	if Controller.grabbed == "FoodButton":
		get_parent().texture = pressed_texture
		if Controller.food_count > 0 and out:
			Controller.food_count -= 1;
			spawn_prefab()
			out = false
	elif Controller.grabbed == "":
		get_parent().texture = normal_texture
		out = true
		
# Function to spawn the prefab
func spawn_prefab():
	if prefab_scene:
		var instance = prefab_scene.instantiate()
		get_tree().current_scene.add_child(instance)
		instance.global_position = (global_position - Vector2(40,10))
		instance.z_as_relative = false
		instance.get_child(0).name = instance.name + str(Controller.stuff_count)
		Controller.stuff_count += 1
		instance.z_index = 20
