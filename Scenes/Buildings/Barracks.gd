extends Node

func _ready():
	pass

func spawn(Minions,Spawn):
	for barrack in get_children():		
		if get_parent().temp_instance == barrack:
			continue
		var scene = load("res://Scenes/Minions/Minion/minion.tscn")
		var instance = scene.instantiate()
		instance.position = Vector2(Spawn.position.x,randi_range(-Spawn.scale.y,Spawn.scale.y))
		Minions.add_child(instance)
