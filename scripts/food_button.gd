extends Area2D

@export var prefab_path: String = "res://objects/food.tscn"
@export var normal_texture: Texture2D = preload("res://textures/ui/vending_button_up.png")
@export var pressed_texture: Texture2D = preload("res://textures/ui/vending_button_down.png")

var prefab_scene: PackedScene = null

var out = true

func _ready():
	add_to_group("grabbable")
	prefab_scene = load(prefab_path)

func _physics_process(delta: float) -> void:
	if Controller.grabbed == self:
		get_parent().texture = pressed_texture
		if Controller.food_count > 0 and out:
			Controller.food_count -= 1;
			spawn_prefab()
			out = false
	elif Controller.grabbed == null:
		get_parent().texture = normal_texture
		out = true
		
# Function to spawn the prefab
func spawn_prefab():
	if prefab_scene:
		var instance = prefab_scene.instantiate()
		get_tree().current_scene.add_child(instance)
		instance.global_position = (global_position - Vector2(40,10))
		instance.z_as_relative = false
		instance.z_index = 20
