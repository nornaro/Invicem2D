extends Node

@export var elapsed_time = 0.0

func _process(delta):
	elapsed_time += delta
	if elapsed_time >= 10.0 && get_child_count(): # 60 seconds is a minute
		for barrack in get_children():
			if !barrack.temp_instance: 
				barrack.spawn_minion($"../../Minions")
		elapsed_time = 0.0
	pass
