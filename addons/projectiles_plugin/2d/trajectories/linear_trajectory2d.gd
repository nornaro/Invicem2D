@tool
extends Trajectory2D
class_name LinearTrajectory2D


func get_delta(delta: float, _total_time: float) -> Vector2:
	return Vector2(delta, 0)

