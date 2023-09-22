extends RigidBody2D

@export var projectileSpeed = [0, 0] # min, max
@onready var Tower = $".."
var target = null  
var speed = 0
# mass = dmg
# scale = size

func _ready():
	if !Tower.Data.has("projectileSpeed"):
		return
#		Tower.Data["projectileSpeed"] = projectileSpeed
	projectileSpeed = Tower.Data["projectileSpeed"]
	speed = projectileSpeed[0]
	gravity_scale = 0
	add_to_group("projectiles")

func _physics_process(delta):
	if speed < projectileSpeed[1]:
		speed += delta*(projectileSpeed[1]-projectileSpeed[0])
	if is_instance_valid(target):
		linear_velocity = (target.global_position - global_position-Vector2(target.speed, 0)).normalized()*projectileSpeed
	if !is_instance_valid(target):
		queue_free()

func _on_area_2d_area_entered(area):
	if !area.get_parent().is_in_group("minions"):
		return
	queue_free()
	area.get_parent().hp -= mass
	if area.get_parent().hp <= 0:
		area.get_parent().queue_free()
