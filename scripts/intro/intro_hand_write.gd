extends Sprite2D

@export var sprite_texture: Texture2D

@export var cons_offset = Vector2(-23, -260)

func _process(delta) -> void:
	if InputEventMouseMotion and get_global_mouse_position().x > 0 and get_global_mouse_position().y > 0 and Controller.INTRO_PROGRESS_AMOUNT > 19:
		position = get_global_mouse_position() + cons_offset;
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			var sprite = Sprite2D.new()
			sprite.texture = sprite_texture
			sprite.position = get_global_mouse_position()
			sprite.z_index = -1
			var parent_node = get_parent()
			if parent_node:
				parent_node.add_child(sprite)
