extends Sprite2D

@export var down = true
@export var up = false
@export var close_point = 0
@export var open_point = -634
@export var writing = true
@export var start = 0
@export var end = 6
@export var speed = 600
@export var next_scene = ""
var time = 0
var scene_location
func _ready() -> void:
	if next_scene in Controller:
		scene_location = Controller.get(next_scene)

func _process(delta) -> void:
	if writing:
		if (Controller.INTRO_PROGRESS_AMOUNT > end):
			if(position.y < close_point):
				position.y += delta * speed
			else:
				position.y = close_point
				Controller.change_scene(scene_location)
				
	else:
		time += delta
		if down and time > end:
			if(position.y < close_point):
				position.y += delta * speed
			else:
				position.y = close_point
				if scene_location: Controller.change_scene(scene_location)
			
		elif up and time > start: 
			if(position.y > open_point):
				position.y -= delta * speed
			else:
				position.y = open_point
			
