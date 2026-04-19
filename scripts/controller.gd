extends Node

var DEBUG = true

var hu_type = "wander"
var hu_types = ["wander", "chase", "grab", "speech", "poop"]
var hu_mode = "still"
var hu_roam = ["still","up", "down", "right","left"]
var hu_speech_queue = ["wassup","why can't i see my peen :(","christ=lord","trigon collective"]

#0 is bad, 1 is good
var hu_hevhell = 0.5
var hu_hungry = 0.5
var hu_bored = 0.5

var day = 0
var prev_login = 0

var grabbed = ""

func change_scene(scene):
	get_tree().change_scene_to_file(scene)

func get_scene_name():
	return get_tree().current_scene.name  
