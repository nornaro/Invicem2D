extends Node

var elapsed_time = 0.0
@onready var Tower = $".."

func _ready():
	set_process(true) # Starts the _process function.

func _process(delta):
	if !Tower.Data["projectile"]:
		return
	if !Tower.Data["aspd"]:
		return
	elapsed_time += delta
	if elapsed_time >= 1 / Tower.Data["aspd"]:
		elapsed_time = 0.0
	if Tower.Data["targeting"].size() == 0:
		return
	for target in Tower.Data["targeting"]:
		if is_instance_valid(target):
			fire_projectile(target.get_parent())

func fire_projectile(target):
	var projectile_scene = load("res://turrets/Projectiles/"+Tower.Data["projectile"]+".tscn")	
	var projectile_instance = projectile_scene.instantiate()
	projectile_instance.target = target
	add_child(projectile_instance)

