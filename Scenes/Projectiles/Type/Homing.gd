extends RigidBody2D

@export var projectileSpeed = [0, 0] # min, max
var target = null  
var speed = 0

func _ready():
	set_physics_process(true)
	speed = projectileSpeed[0]
	gravity_scale = 0
	add_to_group("projectiles")

func _physics_process(delta):
	if !is_instance_valid(target):
		queue_free()
		return
	linear_velocity = ((target.global_position-global_position)*speed).normalized()*speed

func _on_area_2d_area_entered(area):
	if !area.get_parent().is_in_group("minions"):
		return
	queue_free()
	area.get_parent().Data["hp"] -= mass
	if area.get_parent().Data["hp"] <= 0:
		area.get_parent().queue_free()
