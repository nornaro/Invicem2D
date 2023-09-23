extends RigidBody2D

@export var speed = 50000
var target = Vector2()  
# mass = dmg
# scale = size

func _ready():
	gravity_scale = 0
	add_to_group("projectiles")

func _physics_process(delta):
	if is_instance_valid(target):
		linear_velocity = (target.global_position - global_position-Vector2(target.speed, 0)).normalized()*speed
		print(linear_velocity)
	if !is_instance_valid(target):
		queue_free()

func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("minions"):  # Assuming you've added minions to the "minions" group
		area.get_parent().hp -= mass
		queue_free()
		if area.get_parent().hp <= 0:
			area.get_parent().queue_free()
	
	pass # Replace with function body.
