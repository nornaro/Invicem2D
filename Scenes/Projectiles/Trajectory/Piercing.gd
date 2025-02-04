extends RigidBody2D

var Data = {}
var target = null  

func _ready():
	set_physics_process(true)
	gravity_scale = 0
	add_to_group("projectiles")
	var speed = 50 * (Data.Upgrades.ProjectileSpeed + 10)
	linear_velocity = ((
		(target.global_position-global_position) * 
			speed + 
			target.get_parent().linear_velocity*sqrt(speed)*5).normalized() * 
			speed)

func _on_area_2d_area_entered(area):
	if !area.get_parent().is_in_group("minions"):
		return
	area.get_parent().hurt(Data.Upgrades.Damage,Data.Upgrades.Penetration)
