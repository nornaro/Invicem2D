extends RigidBody2D

@export var projectileSpeed = 500
var target = null

func _ready():
	gravity_scale = 0
	add_to_group("projectiles")
	if !is_instance_valid(target):
		queue_free()
		return
	linear_velocity = target.global_position.normalize()*projectileSpeed
	move_and_collide(linear_velocity)

func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("minions"):
		area.get_parent().hp -= 1
		queue_free()
		if area.get_parent().hp <= 0:
			area.get_parent().queue_free()
