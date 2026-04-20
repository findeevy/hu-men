extends Label

func _physics_process(delta: float) -> void:
	text = "food\n" + str(Controller.food_count)+ " cnt"
