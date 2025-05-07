extends Node

var paused:bool = false

func _ready() -> void:
	process_mode=PROCESS_MODE_ALWAYS
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		get_tree().paused = !get_tree().paused
