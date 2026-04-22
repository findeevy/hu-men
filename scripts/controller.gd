extends Node

var DEBUG = true

var next_uid = 0;

var hu_type = "chase"

var hu_types = ["chase", "chase", "grab", "speech", "poop"]
var hu_mode = "still"
var hu_roam = ["still","up", "down", "right","left"]
var hu_speech_queue = ["wassup","why can't i see my peen :(","christ=lord","trigon collective"]
var hu_stuff = {}
var food_count = 4

var vend_stuff = {}

#0 is bad, 1 is good
var hu_hevhell = 0.5
var hu_hungry = 0.5
var hu_bored = 0.5

var day = 0
var prev_login = 0

var grabbed = null
var stuff_count = 0

func change_scene(scene):
	get_tree().change_scene_to_file(scene)

func get_scene_name():
	return get_tree().current_scene.name  
