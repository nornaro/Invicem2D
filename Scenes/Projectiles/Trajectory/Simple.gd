extends RigidBody2D

var Data: Dictionary = {}
var target = null
var velocity

func _ready():
	gravity_scale = 0
	add_to_group("projectile")
	if !is_instance_valid(target):
		queue_free()
		return
	var speed = 50 * (Data.Upgrades.ProjectileSpeed + 10)
	var target_dir = (target.global_position - global_position).normalized()
	linear_velocity = target_dir * speed
	linear_velocity = 0.01 * Vector2(randf_range(-(20-Data.Spread),20-Data.Spread),randf_range(-(20-Data.Spread),20-Data.Spread))

func _on_area_2d_area_entered(area):
	if !area is MinionArea:
		return
	queue_free()
	area.get_parent().hurt(Data.Upgrades.Damage,Data.Upgrades.Penetration)
