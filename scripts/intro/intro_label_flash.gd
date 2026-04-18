extends Label
#make a flasher that then says press space after you draw a bit!

@export var special = true
var title = text

func flicker(help: String) -> String:
	if (text == help):
		return ""
	return help

func _process(delta) -> void:
	if special:
		if Controller.INTRO_PROGRESS_AMOUNT > 23:
			text = flicker("MIND\nDISJOINTS\nBODY")
		elif Controller.INTRO_PROGRESS_AMOUNT > 19 and Controller.INTRO_PROGRESS_AMOUNT < 21:
			text = flicker("ENSCRIBE\nYOUR\nMARK")
		elif Controller.INTRO_PROGRESS_AMOUNT < 5:
			text = flicker("ENACT\nYOUR\nWILL")
		else:
			text = ""
	else:
		text = flicker(title)
