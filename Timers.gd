extends Node

var paused = false

func _ready():
	process_mode=PROCESS_MODE_ALWAYS
	
func _input(event):
	if event.is_action_pressed("Pause"):
		get_tree().paused = !get_tree().paused
