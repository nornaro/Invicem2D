@tool
extends Trajectory2D
class_name CircularTrajectory2D

@export var rotation_time: float = 10.0
@export var radius: float = 100.0


func get_delta(delta: float, total_time: float) -> Vector2:
	var prev_t: float = total_time/rotation_time/2.0/PI
	var current_t: float = (total_time + delta)/rotation_time/2.0/PI
	var prev: Vector2 = Vector2(sin(prev_t), cos(prev_t))
	var new: Vector2 = Vector2(sin(current_t), cos(current_t))
	return radius*(new - prev)

