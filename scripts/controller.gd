extends Node

var GAME_DATE = "6/9/2055"
var DEBUG = true

var ICON_OFFSET = Vector2(-30,-8)
var ICON_SIZE = Vector2(60,60)

var INTRO_PROGRESS_AMOUNT = 0
var INTRO_AUDIO_RAIN = "res://audio/sfx/rain.mp3"

var OS_SCREEN_SIZE = Vector2(720,540)
var OS_SCREEN_PADDING = Vector2(0,30)
var OS_TERMINAL_OUTPUT = ""
var OS_OPEN_TIMER = 0.2
var OS_WINDOW_BAR_HEIGHT = 10
var OS_UPDATES = null
var OS_NETWORK = "BIOFIBER"
var OS_AVAILABLE_NETWORKS = ["NONE", "BIOFIBER", "NLH_GUEST_WIFI"]
var OS_BACKGROUND = "NUEVO.BMP"
var OS_AVAILABLE_BACKGROUNDS = ["TOWER.BMP", "DARK.BMP", "NUEVO.BMP"]
var OS_RAM = "133GB/512GB"
var OS_CPU = "SINOTECH 3042 MICROPROCESSOR"
var OS_GPU = "APX 8500X GRAPHICS MODULE"
var OS_DISK = "3TB/1.2PB"
var OS_USER = "CARET"
var OS_VERSION = "NEUR(OS) BETA 0.7.29"
var OS_LIGHT_UP = false

var SRC_SCENE_NEUROS_DESKTOP = "res://scenes/os_terminal.tscn"
var SRC_SCENE_NEUROS_LOGIN = "res://scenes/os_login.tscn"
var SRC_SCENE_TEST_SPACIAL = "res://scenes/test_spacial.tscn"
var SRC_SCENE_FPS_GROCERY = "res://scenes/test_groc.tscn"

var SRC_SCENE_INTRO_HOSPITAL = "res://scenes/intro_hospital.tscn"
var SRC_SCENE_INTRO_SIGN = "res://scenes/intro_flesh_god.tscn"
var SRC_SCENE_INTRO_PRESENT = "res://scenes/intro_present.tscn"
var SRC_SCENE_INTRO_OPERATE = "res://scenes/intro_operate.tscn"

var SRC_FPS_DIALOGUE = "res://dialogue/"
var SRC_FPS_SCENE = "res://scenes/"
var SRC_FPS_RETICLE_YES = "res://textures/ui/fps_ret_hov_bg"
var SRC_FPS_RETICLE_NO = "res://textures/ui/fps_ret_def_bg"
var SRC_FPS_PAUSED = "res://textures/ui/fps_paused"
var SRC_FPS_TEXT_LARGE = "res://textures/ui/fps_text_large_bg"
var SRC_FPS_TEXT_TOP_BG = "res://textures/ui/fps_text_top_bg"
var SRC_FPS_TEXT_TOP_BH = "res://textures/ui/fps_text_top_bh"
var SRC_FPS_TEXT_BOT_BG = "res://textures/ui/fps_text_bot_bg"
var SRC_FPS_TEXT_BOT_BH = "res://textures/ui/fps_text_bot_bh"
var SRC_FPS_HAND = "res://textures/ui/fps_hand_1"

var SRC_OS_BUTTON_UP = "res://textures/ui/os_button_shutdown.png"
var SRC_OS_BUTTON_DOWN = "res://textures/ui/os_button_shutdown_down.png"
var SRC_OS_WINDOW_EXIT_BUTTON_UP = "res://textures/ui/os_exit_button_up.png"
var SRC_OS_WINDOW_EXIT_BUTTON_DOWN = "res://textures/ui/os_exit_button_down.png"
var SRC_OS_BACKGROUND_TOWER = "res://textures/ui/os_background_tower.png"
var SRC_OS_BACKGROUND_DARK = "res://textures/ui/os_background_dark.png"
var SRC_OS_BACKGROUND_NUEVO = "res://textures/ui/os_background_nuevo.png"
var SRC_OS_LOG = "res://save_data/os.log"

var FPS_RAYCAST_INTERSECT = null
var FPS_IS_TALKING = false
var FPS_UI_MOVING = false
var FPS_OPT2_MOVING = false
var FPS_OPT2_STAR = false
var FPS_INTERACTION_DATABASE = {}
var FPS_DIALOGUE_DATABASE = {}
var FPS_CURRENT_CHAR_SPEECH_TEXT = ""
var FPS_CURRENT_OPT1_SPEECH_TEXT = ""
var FPS_CURRENT_OPT2_SPEECH_TEXT = ""
var FPS_IS_WALKING = true
var FPS_IS_PAUSED = false
var FPS_UI_SWITCHING = false
var FPS_CHOICE = null
var FPS_BLACK = Vector4(0.01568627,0,0.172549019,1)
var FPS_BROWN = Vector4(0.1372549,0.04313725,0,1)
var FPS_MODE = ".png"

var grabbed_item = null
var focused_window = null
var mouse_last_position = Vector2(0,0)
var icons_dict = {"brain":"(0, 270)","leave":"(0, 30)","patient":"(0, 210)","settings":"(0, 150)","terminal":"(0, 90)"}
var windows_dict = {}
var mouse_moving = false
var top_window_z_index = 2
var grab_is_icon = false
var temp_icon_pos = Vector2(0,0)
var program_to_run = null
var program_to_kill = null

#General functions...
func change_scene(scene):
	get_tree().change_scene_to_file(scene)

func get_scene_name():
	return get_tree().current_scene.name  

static func string_to_vector2(string := "") -> Vector2:
	if string:
		var new_string: String = string
		new_string = new_string.erase(0, 1)
		new_string = new_string.erase(new_string.length() - 1, 1)
		var array: Array = new_string.split(", ")
		return Vector2(int(array[0]), int(array[1]))

	return Vector2.ZERO

func fps_select_option():
	#get our index as well as the interaction data
	var index = FPS_INTERACTION_DATABASE[FPS_RAYCAST_INTERSECT]
	var choice_data = FPS_DIALOGUE_DATABASE[FPS_RAYCAST_INTERSECT][index].split("|")
	var option_choice = null
	var option_index = null
	var option_data = null
	
	match Controller.FPS_CHOICE:
		1:
			option_choice = choice_data[1]
			option_index = choice_data[2]
			option_data = choice_data[4]
		2:
			option_choice = choice_data[5]
			option_index = choice_data[6]
			option_data = choice_data[8]
	
	FPS_INTERACTION_DATABASE[FPS_RAYCAST_INTERSECT] = option_index
	index = FPS_INTERACTION_DATABASE[FPS_RAYCAST_INTERSECT]
	choice_data = FPS_DIALOGUE_DATABASE[FPS_RAYCAST_INTERSECT][index].split("|")
	
	match option_choice:
		"y":
			FPS_IS_WALKING = true
			FPS_IS_TALKING = false
			FPS_UI_MOVING = true
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		"l":
			FPS_IS_WALKING = true
			FPS_IS_TALKING = false
			FPS_UI_MOVING = true
			change_scene(SRC_FPS_SCENE+option_data+".tscn")
		"n":
			print(choice_data)
			FPS_INTERACTION_DATABASE[FPS_RAYCAST_INTERSECT] = option_index
			FPS_CURRENT_CHAR_SPEECH_TEXT = choice_data[0]
			FPS_CURRENT_OPT1_SPEECH_TEXT = choice_data[3]
			FPS_CURRENT_OPT2_SPEECH_TEXT = choice_data[7]
	Controller.FPS_CHOICE = null

func fps_get_opt1_speech(data):
	return data.split("|")[3] 

func fps_get_opt2_speech(data):
	return data.split("|")[7] 

func fps_get_char_speech(data):
	return data.split("|")[0] 

func fps_render_char_speech(text):
	if FPS_CURRENT_CHAR_SPEECH_TEXT != text:
		text = FPS_CURRENT_CHAR_SPEECH_TEXT
	return text

#First person functions, including dialogue systems...
func fps_level_dialogue_load(level_name):
	var json = JSON.new()
	if FileAccess.file_exists(SRC_FPS_DIALOGUE+level_name+".json"):
		FPS_DIALOGUE_DATABASE = json.parse_string(FileAccess.get_file_as_string(SRC_FPS_DIALOGUE+level_name+".json"))
		if DEBUG: print(FPS_DIALOGUE_DATABASE)

#Desktop OS functions and related stuff...
func os_logout():
	os_command_line_message(OS_USER+" LOGGED OFF AT "+ Controller.os_get_real_time() +".")
	os_command_print_line()
	os_save_desktop()
	change_scene(Controller.SRC_SCENE_NEUROS_LOGIN)

func os_shutdown():
	change_scene("res://scenes/test_spatial.tscn")

func os_login():
	change_scene(Controller.SRC_SCENE_NEUROS_DESKTOP)

func os_close_window(window_name):
	os_command_line_message('Terminated "'+window_name+'.prgm".')
	windows_dict[window_name][1] = false
	focused_window = null

func os_data_read_to_dict():
	var data = {}
	data["OS_UPDATES"] = OS_UPDATES
	data["OS_CPU"] = OS_CPU
	data["OS_GPU"] = OS_GPU
	data["OS_RAM"] = OS_RAM
	data["OS_VERSION"] = OS_VERSION
	data["OS_DISK"] = OS_DISK
	data["OS_BACKGROUND"] = OS_BACKGROUND
	data["OS_NETWORK"] = OS_NETWORK
	data["OS_USER"] = OS_USER
	data["OS_TERMINAL_OUTPUT"] = OS_TERMINAL_OUTPUT
	data["icons_dict"] = icons_dict
	return data

func os_data_write_from_dict(data):
	OS_UPDATES = data["OS_UPDATES"]
	OS_CPU = data["OS_CPU"]
	OS_GPU = data["OS_GPU"] 
	OS_RAM = data["OS_RAM"]
	OS_VERSION = data["OS_VERSION"]
	OS_DISK = data["OS_DISK"]
	OS_BACKGROUND = data["OS_BACKGROUND"]
	OS_NETWORK = data["OS_NETWORK"]
	OS_USER = data["OS_USER"]
	OS_TERMINAL_OUTPUT = data["OS_TERMINAL_OUTPUT"]
	icons_dict = data["icons_dict"]
	
	#Cleaning up the JSON data before use...
	for i in icons_dict:
		icons_dict[i] = string_to_vector2(icons_dict[i])

func os_save_desktop():
	var data = JSON.stringify(os_data_read_to_dict())
	var file = FileAccess.open(SRC_OS_LOG, FileAccess.WRITE)
	file.store_string(data)

func os_load_desktop():
	var json = JSON.new()
	if FileAccess.file_exists(SRC_OS_LOG):
		var data = null
		data = json.parse_string(FileAccess.get_file_as_string(SRC_OS_LOG))
		os_data_write_from_dict(data)
	else:
		os_save_desktop()

func os_set_background(background_index):
	OS_BACKGROUND = OS_AVAILABLE_BACKGROUNDS[background_index]
	os_save_desktop()

func os_disconnect_network():
	if OS_NETWORK != "NONE":
		os_command_line_message('Disconnected from "'+OS_NETWORK+'".')
		OS_NETWORK = "NONE"
	else:
		os_command_line_message('Not currently connected to a network.')
	os_save_desktop()

func os_connect_network(network_name):
	if network_name == OS_NETWORK and network_name != "NONE":
		os_command_line_message('Already connected to "'+network_name+'".')
	elif network_name in OS_AVAILABLE_NETWORKS and network_name != "NONE":
		OS_NETWORK = network_name
		os_command_line_message('Connected to "'+network_name+'".')
	else:
		os_command_line_message('"'+network_name+'" network not found.')
	os_save_desktop()

func os_check_updates():
	if OS_NETWORK == "NONE":
		os_command_line_message('Network unavailable, cannot check for updates.')
	elif OS_UPDATES == null:
		os_command_print_line()
		os_command_line_message('Checking for updated packets on '+OS_NETWORK+".")
		for i in icons_dict:
			os_command_line_message('"'+i+'.prgm" is up to date.')
		os_command_print_line()

func os_poll_data(data):
	os_command_line_message("----------------------------------------------------------------------------")
	match data:
		"NETWORK":
			os_command_line_message(OS_NETWORK)
			os_command_print_line()
			return
		"NETWORKS":
			for i in OS_AVAILABLE_NETWORKS:
				if i != "NONE": os_command_line_message(i)
			os_command_print_line()
			return
		"PROGRAMS":
			for i in icons_dict:
				os_command_line_message(i+".pckg")
			os_command_print_line()
			return
		"RESOLUTION":
			os_command_line_message(str(OS_SCREEN_SIZE.x) + " X " + str(OS_SCREEN_SIZE.y))
			os_command_print_line()
			return
		"BACKGROUND":
			os_command_line_message(OS_BACKGROUND)
			os_command_print_line()
			return
		"CPU":
			os_command_line_message(OS_CPU)
			os_command_print_line()
			return
		"GPU":
			os_command_line_message(OS_GPU)
			os_command_print_line()
			return
		"RAM":
			os_command_line_message(OS_RAM)
			os_command_print_line()
			return
		"DISK":
			os_command_line_message(OS_DISK)
			os_command_print_line()
			return
		"TIME":
			os_command_line_message(os_get_real_time())
			os_command_print_line()
			return
		"DATE":
			os_command_line_message(GAME_DATE)
			os_command_print_line()
			return
		"VERSION":
			os_command_line_message(OS_VERSION)
			os_command_print_line()
			return
		"USER":
			os_command_line_message(OS_USER)
			os_command_print_line()
			return

	os_command_line_message("DATA NOT AVAILABLE TO BE POLLED.")
	os_command_print_line()
	
func os_command_print_line():
	os_command_line_message("----------------------------------------------------------------------------")

func os_command_parse_input(message):
	message = message.to_upper()
	if message.replace(' ', '') == "HELP":
		os_command_line_message("HELP")
		os_command_print_line()
		os_command_line_message('RUN (PROGRAM NAME) -> START PROGRAM\nKILL (PROGRAM NAME) -> STOP PROGRAM\nUPDATE -> SEARCH FOR UPDATED PACKETS\nSHUTDOWN -> TURN OFF COMPUTER\nLOGOUT -> LOG OUT USER\nCONNECT (NETWORK NAME) -> CONNECT TO NETWORK\nDISCONNECT -> CONNECT FROM NETWORK\nPOLL (DATA NAME) -> CHECK OS DATA\nLIST -> SHOW AVAILABLE OS DATA')
		os_command_print_line()

	elif message.replace(' ', '') == "LIST":
		os_command_line_message("LIST")
		os_command_print_line()
		os_command_line_message('HARDWARE DATA:\nCPU, GPU, RAM, DISK, RESOLUTION\nOS DATA:\nPROGRAMS, NETWORK, NETWORKS, VERSION\nUSER DATA:\nUSER, BACKGROUND, TIME, DATE')
		os_command_print_line()

	elif message.replace(' ', '') == "LOGOUT":
		os_logout()
	
	elif message.replace(' ', '') == "SHUTDOWN":
		os_shutdown()

	elif message.replace(' ', '') == "UPDATE":
		os_command_line_message(message)
		os_check_updates()
		
	elif  message.begins_with("POLL "):
		os_command_line_message(message)
		message = message.replace('POLL ', '')
		message = message.replace(' ', '')
		os_poll_data(message)

	elif message.replace(' ', '') == "DISCONNECT":
		os_command_line_message(message)
		os_disconnect_network()

	elif message.begins_with("CONNECT "):
		os_command_line_message(message)
		message = message.replace('CONNECT ', '')
		message = message.replace(' ', '')
		os_connect_network(message)
				
	elif message.begins_with("RUN "):
		os_command_line_message(message)
		message = message.replace('.PRGM', '')
		message = message.replace('RUN ', '')
		message = message.replace(' ', '')
		if message.to_lower() in Controller.windows_dict:
			if Controller.windows_dict[message.to_lower()][1] == false:
				Controller.windows_dict[message.to_lower()][1] = true
				os_command_line_message('Opened "'+message+'.prgm".')
			else:
				os_command_line_message('"'+message+'.prgm" is already running.')
		else:
			os_command_line_message('"'+message+'.prgm" PROGRAM NOT AVAILABLE.')

	elif message.begins_with("KILL "):
		os_command_line_message(message)
		message = message.replace('.PRGM ', '')
		message = message.replace('KILL ', '')
		message = message.replace(' ', '')
		if message.to_lower() in Controller.windows_dict:
			if Controller.windows_dict[message.to_lower()][1] == true:
				Controller.windows_dict[message.to_lower()][1] = false
				os_command_line_message('Terminated "'+message+'.prgm".')
			else:
				os_command_line_message('"'+message+'.prgm" is not running.')
		else:
			os_command_line_message('"'+message+'.prgm" PROGRAM NOT AVAILABLE.')
	else:
		os_command_line_message(message)
		os_command_line_message('"'+message+'" COMMAND UNKNOWN, PLEASE TYPE "HELP".')

func os_command_line_message(message):
	OS_TERMINAL_OUTPUT += "\n" + message
	if len(OS_TERMINAL_OUTPUT.split("\n")) > 12:
		var lines = len(OS_TERMINAL_OUTPUT.split("\n"))
		OS_TERMINAL_OUTPUT = "\n".join(OS_TERMINAL_OUTPUT.split("\n").slice(lines-12, lines))
	os_save_desktop()

func os_get_real_time():
	return Time.get_time_string_from_system()

func os_item_check_border(item):
	return 0 <= item.get_position().x and (item.get_size().x + item.get_position().x) < OS_SCREEN_SIZE.x and 0 <= item.get_position().y and (item.get_size().y + item.get_position().y) < OS_SCREEN_SIZE.y

func os_mouse_moving(mouse_coordinates):
	var past_mouse_coordinates = mouse_last_position
	mouse_last_position = mouse_coordinates
	mouse_moving = past_mouse_coordinates == mouse_coordinates

func os_mouse_on_screen_x(mouse_coordinates_x):
	return 0 <= mouse_coordinates_x and mouse_coordinates_x < OS_SCREEN_SIZE.x - ICON_SIZE.x - ICON_OFFSET.x

func os_mouse_on_screen_y(mouse_coordinates_y):
	return 36 <= mouse_coordinates_y and mouse_coordinates_y < OS_SCREEN_SIZE.y - ICON_SIZE.y - ICON_OFFSET.y

func os_item_grab(item, mouse_position, offset, is_icon):
	if os_mouse_on_screen_x(mouse_position.x):
		item.position.x = mouse_position.x + offset.x
	if os_mouse_on_screen_y(mouse_position.y):
		item.position.y = mouse_position.y + offset.y
	grab_is_icon = is_icon
	if is_icon:
		temp_icon_pos = Vector2(roundi(item.get_position().x/ICON_SIZE.x)*ICON_SIZE.x,roundi(item.get_position().y/ICON_SIZE.y)*ICON_SIZE.y-OS_SCREEN_PADDING.y)
		if temp_icon_pos in icons_dict.values():
			temp_icon_pos = icons_dict[item.program_name]
		if temp_icon_pos.x < 0 or temp_icon_pos.y < 0: 
			temp_icon_pos = icons_dict[item.program_name]
		else: 
			temp_icon_pos = Vector2(roundi(item.get_position().x/ICON_SIZE.x)*ICON_SIZE.x,roundi(item.get_position().y/ICON_SIZE.y)*ICON_SIZE.y-OS_SCREEN_PADDING.y)

func os_item_icon_snap(icon):
	icon.position = Vector2(roundi(icon.get_position().x/ICON_SIZE.x)*ICON_SIZE.x,roundi(icon.get_position().y/ICON_SIZE.y)*ICON_SIZE.y-OS_SCREEN_PADDING.y)
	if icon.position.x < 0 or icon.position.y < 0: 
		icon.position = icons_dict[icon.program_name]
	else: 
		icon.position = Vector2(roundi(icon.get_position().x/ICON_SIZE.x)*ICON_SIZE.x,roundi(icon.get_position().y/ICON_SIZE.y)*ICON_SIZE.y-OS_SCREEN_PADDING.y)
	if icon.position in icons_dict.values():
		icon.position = icons_dict[icon.program_name]
	else:
		icons_dict[icon.program_name] = icon.position
		os_save_desktop()

func os_item_overlap(item_position, item_size, mouse_position):
	return item_position.x < mouse_position.x and mouse_position.x < (item_position.x + item_size.x) and item_position.y < mouse_position.y and mouse_position.y < (item_position.y + item_size.y)
