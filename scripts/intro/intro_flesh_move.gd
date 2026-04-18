extends Sprite2D

@export var start_time = 1
@export var stop_time  = 2
@export var move  = Vector2i(-100,0)

var start_loc = Vector2i(0,0)
var stop_loc = Vector2i(0,0)

func _ready() -> void:
	start_loc = Vector2i(int(position.x),int(position.y)) 
	stop_loc = start_loc + move
	
func _process(delta) -> void:
	if Controller.INTRO_PROGRESS_AMOUNT > stop_time:
		position = stop_loc
	elif Controller.INTRO_PROGRESS_AMOUNT >= start_time:
		var amount = (Controller.INTRO_PROGRESS_AMOUNT - start_time)/(stop_time - start_time)
		position.x = lerp(start_loc.x, stop_loc.x, amount)
		position.y = lerp(start_loc.y, stop_loc.y, amount)
