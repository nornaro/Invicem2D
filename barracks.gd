extends Node2D

@export var elapsed_time = 0.0
var mobcount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsed_time += delta
	if elapsed_time >= 10.0 && get_child_count(): # 60 seconds is a minute
		for barrack in get_children():
			if !barrack.temp: 
				barrack.spawn_minion($"../../Minion")
#				mobcount += 1
#				$"../../MobCount".text = str(mobcount)
		elapsed_time = 0.0
	pass
