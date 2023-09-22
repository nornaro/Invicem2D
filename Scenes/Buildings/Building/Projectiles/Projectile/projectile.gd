extends RigidBody2D

@export var speed = 500
var target = Vector2()  
# mass = dmg
# scale = size

func _ready():
	gravity_scale = 0
	add_to_group("projectiles")
#	if target:
##		linear_velocity = (global_position - (target.global_position-Vector2(target.speed*100000/speed,0))).normalized() * speed * Vector2(-1,-1)
#		var relative_position = target.global_position - global_position
#		var d = relative_position.length()
#
#		# Coefficients for the quadratic equation
#		var a = speed*speed + target.speed*target.speed
#		var b = -2 * d * speed
#		var c = d*d
#
#		# Discriminant
#		var D = -(b*b - 4*a*c)
#		var rootD = sqrt(D)
#		var t1 = (-b + rootD) / (2*a)
#		var t2 = (-b - rootD) / (2*a)
#
#		# You need to choose the smallest positive t value
#		var t = 0
#		if t2 > 0: t = t2
#		if t1 > 0 and t2 > 0: t = min(t1, t2)
#		if t1 > 0: t = t1
#
#		var predicted_position = target.global_position - Vector2(t*speed/2 , 0)
#		linear_velocity = (predicted_position - global_position).normalized()*speed

func _physics_process(delta):
	if is_instance_valid(target):
		linear_velocity = (target.global_position - global_position-Vector2(target.speed, 0)).normalized()*speed
	if !is_instance_valid(target):
		queue_free()

func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("minions"):  # Assuming you've added minions to the "minions" group
		area.get_parent().hp -= mass
		queue_free()
		if area.get_parent().hp <= 0:
			area.get_parent().queue_free()
	
	pass # Replace with function body.
