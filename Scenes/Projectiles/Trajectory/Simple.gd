extends RigidBody2D

var Data = {}
var target = null
var velocity

func _ready():
	gravity_scale = 0
	add_to_group("projectiles")
	if !is_instance_valid(target):
		queue_free()
		return
	var speed = 50 * (Data.Upgrades.ProjectileSpeed + 10)
	var target_dir = (target.global_position - global_position).normalized()
	linear_velocity = target_dir * speed

func _on_area_2d_area_entered(area):
	if !area.get_parent().is_in_group("minions"):
		return
	queue_free()
	area.get_parent().hurt(Data.Upgrades.Damage,Data.Upgrades.Penetration)
