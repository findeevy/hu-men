extends Sprite2D

@onready var godhand = preload("res://textures/ui/godhand.png")
@onready var godpinch = preload("res://textures/ui/godpinch.png")
@onready var godhandl = preload("res://textures/ui/godhandl.png")
@onready var godpinchl = preload("res://textures/ui/godpinchl.png")

func _process(delta: float) -> void:
	get_node_under_mouse()
	if InputEventMouseMotion and get_global_mouse_position().x > 0 and get_global_mouse_position().y > 0:
		position = get_global_mouse_position();


func find_grab_target(node: Node) -> Node:
	var current = node
	while current != null:
		if current.is_in_group("grabbable"):
			return current
		current = current.get_parent()
	return null

func get_absolute_z_index(node: CanvasItem) -> int:
	var z = node.z_index
	if node.z_as_relative:
		var parent = node.get_parent()
		if parent is CanvasItem:
			z += get_absolute_z_index(parent)
	return z

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
			var effective_z = get_absolute_z_index(c)
			if effective_z > top_z:
				top_z = effective_z
				top_collider = c

	var holding = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)

	if not holding:
		# Mouse released — always drop whatever we had
		Controller.grabbed = null
		if top_collider:
			texture = godhandl
		else:
			texture = godhand
	else:
		# Mouse held — only pick something up if we aren't already holding anything
		if Controller.grabbed == null and top_collider:
			Controller.grabbed = find_grab_target(top_collider)
		if top_collider or Controller.grabbed != null:
			texture = godpinchl
		else:
			texture = godpinch
	
