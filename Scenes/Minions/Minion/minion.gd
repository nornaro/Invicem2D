extends RigidBody2D

@export var speed = 5
@export var hp = 100
@export var def = 100
@export var size = 1
@export var dodge = 100

func _ready():
	add_to_group("minions")
	scale *= size
	gravity_scale = 0

func _physics_process(delta):
	if get_tree().get_nodes_in_group("true").size()>0:
		return
	if rotation != 0:
		if rotation > 0+delta:
			rotation -= delta
		if rotation < 0-delta:
			rotation += delta
		if abs(rotation) < delta:
			rotation = 0

	move_and_collide(Vector2(-speed,0))
