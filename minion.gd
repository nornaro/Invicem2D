extends RigidBody2D

@export var speed = 3
@export var hp = 100
@export var def = 100
@export var size = 1
@export var dodge = 100

func _ready():
	add_to_group("minions")
	scale *= size

func _physics_process(delta):
	if position.y > 50:
		position.y = 50
	if position.y < -50:
		position.y = -50
	if rotation > 0:
		rotation -= delta
	if rotation < 0:
		rotation += delta
		
	linear_velocity.y = 0
	linear_velocity.x = -speed
	gravity_scale = 0
	move_and_collide(linear_velocity)
