extends RigidBody2D

var target = null
var Data = {}

func _ready():
	set_physics_process(true)
	gravity_scale = 0
	add_to_group("projectiles")

func _physics_process(delta):
	if !is_instance_valid(target):
		queue_free()
		return
	var speed = 50 * (Data.Upgrades.ProjectileSpeed + 10)
	linear_velocity = (((target.global_position-global_position) * 
	speed).normalized()*speed)
	
func _on_area_2d_area_entered(area):
	if !area.get_parent().is_in_group("minions"):
		return
	queue_free()
	area.get_parent().hurt(Data.Upgrades.Damage,Data.Upgrades.Penetration)
