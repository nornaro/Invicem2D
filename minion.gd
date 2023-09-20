extends RigidBody2D

@export var speed = 3
@export var hp = 100
@export var def = 100
@export var size = 1
@export var dodge = 100

func _ready():
	add_to_group("minions")
	scale *= size
	linear_velocity.y = 0
	linear_velocity.x = -speed
	gravity_scale = 0

func _physics_process(delta):
	if get_tree().get_nodes_in_group("minions").size()>=100:
		return
	if position.y > 60:
		position.y = 60
	if position.y < -820:
		position.y = -820
	if position.x > 820:
		position.y = 820
	if position.y < -60:
		position.y = -60
	if rotation > 0:
		rotation -= delta
	if rotation < 0:
		rotation += delta

	move_and_collide(linear_velocity)
