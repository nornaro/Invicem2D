extends RigidBody2D

var target: Node2D = null
var gravity: float = 9.8
var direction: Vector2
var Data: Dictionary = {}

func _ready():
	gravity_scale = 1  # Enable physics gravity
	add_to_group("projectile")

	if !is_instance_valid(target):
		queue_free()
		return
	direction = (target.global_position - global_position).normalized()
	
	var speed = 50 * (Data.ProjectileSpeed + 10)
	var angle_offset = 1/speed
	linear_velocity = direction.rotated(angle_offset) * speed
	var spreadbase = 17	
	var spread = 5 * Vector2(randf_range(-(spreadbase-Data.Spread),spreadbase-Data.Spread),randf_range(-(spreadbase-Data.Spread),spreadbase-Data.Spread))
	linear_velocity += spread

func _on_area_2d_area_entered(area):
	if !area is MinionArea:
		return
	#queue_free()
	area.get_parent().hurt(Data.Damage,Data.Penetration)
