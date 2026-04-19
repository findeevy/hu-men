extends Sprite2D

@onready var godhand = preload("res://textures/ui/godhand.png")
@onready var godpinch = preload("res://textures/ui/godpinch.png")
@onready var godhandl = preload("res://textures/ui/godhandl.png")
@onready var godpinchl = preload("res://textures/ui/godpinchl.png")

func _process(delta: float) -> void:
	get_node_under_mouse()
	if InputEventMouseMotion and get_global_mouse_position().x > 0 and get_global_mouse_position().y > 0:
		position = get_global_mouse_position();


func get_node_under_mouse():
	var space_state = get_world_2d().direct_space_state
	var mouse_pos = get_global_mouse_position()

	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collide_with_areas = true
	query.collide_with_bodies = true

	var results = space_state.intersect_point(query)
	
	var top_collider = null
	var top_z = -INF

	for r in results:
		var c = r.collider
		if c is CanvasItem:
			print(str(c.z_index) +":")
			print(c.name)
			if c.z_index > top_z:
				top_z = c.z_index
				top_collider = c

	if top_collider:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			Controller.grabbed = top_collider.name
			texture = godpinchl
		else:
			Controller.grabbed = ""
			texture = godhandl
	else:
		Controller.grabbed = ""
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			texture = godpinch
		else:
			texture = godhand
	
