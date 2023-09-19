extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var normal_color: Color = Color(1, 1, 1) # original color
var collision_color: Color = Color(1, 0.5, 0.5) # reddish color

func _process(delta):
	var mouse_position = get_global_mouse_position()

	if would_collide_at(mouse_position):
		$"..".modulate = collision_color
	else:
		$"..".modulate = normal_color

func would_collide_at(position: Vector2) -> bool:
	# Get the Physics2DDirectSpaceState
	var space_state = get_world_2d().direct_space_state

	# Get the collision shape's transform
	var shape_transform = $CollisionShape2D.transform

	# Use test_move() to check if moving to the desired position would result in a collision
	return space_state.test_move(global_transform, shape_transform, position - global_position)
