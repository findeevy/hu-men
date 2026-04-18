extends Node

var DEBUG = true

var hu_type = "wander"
var hu_mode = "still"
var hu_roam = ["still","up", "down", "right","left"]
var hu_speech_queue = ["wassup","why can't i see my peen :(","christ=lord","trigon collective"]

var grabbed = ""

func change_scene(scene):
	get_tree().change_scene_to_file(scene)

func get_scene_name():
	return get_tree().current_scene.name  
