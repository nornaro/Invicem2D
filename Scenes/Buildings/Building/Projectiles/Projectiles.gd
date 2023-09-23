extends Node

var elapsed_time = 0.0
@onready var Tower = $"../.."
@onready var Turret = $".."

func _ready():
	set_process(true) # Starts the _process function.

func _process(delta):
	if !Tower.Data.has("projectile"):
		return
	if !Tower.Data.has("aspd"):
		return
	if Turret.targeting.size() == 0:
		return
	var targeting = Turret.targeting
	elapsed_time += delta
	if elapsed_time < 1 / Tower.Data["aspd"][1]:
		return
	elapsed_time = 0.0
	for target in targeting:
		if is_instance_valid(target):
			fire_projectile(target.get_parent())

func fire_projectile(target):
	var scene = load("res://Scenes/Buildings/Building/Projectiles/"+Tower.Data["projectile"]+".tscn")	
	var instance = scene.instantiate()
	instance.position += Vector2(0,60)
	instance.target = target
	add_child(instance)

