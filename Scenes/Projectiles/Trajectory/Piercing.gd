extends RigidBody2D

var Data: Dictionary = {}
var target = null  

func _ready():
	if !target:
		queue_free()
		return
	var tp = target.global_position
	set_physics_process(true)
	gravity_scale = 0
	add_to_group("projectiles")
	var speed = 50 * (Data.ProjectileSpeed + 10)
	$AnimatedSprite2D.scale *= 0.5+0.5/Data.Size
	position += Vector2(1,0) * randf_range(-Data.Size,Data.Size)*2
	linear_velocity = ((
		(tp-global_position) * speed + 
		target.get_parent().linear_velocity*sqrt(speed)*5).normalized() * speed)
	var spread_range = Data.Spread * randf_range(1,2)
	linear_velocity += Data.Spread + spread_range

func _on_area_2d_area_entered(area):
	if !area.get_parent().is_in_group("minions"):
		return
	Data.Damage -= 1
	area.get_parent().hurt(Data)
	if Data.Damage < 1:
		queue_free()
