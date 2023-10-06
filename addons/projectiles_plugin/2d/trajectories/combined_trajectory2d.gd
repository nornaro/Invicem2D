@tool
extends Trajectory2D
class_name CombinedTrajectory2D

@export var trajectories: Array[Trajectory2D]


func get_delta(delta: float, total_time: float) -> Vector2:
	var result: Vector2 = Vector2(0, 0)
	for t in trajectories:
		result += t.get_delta(delta, total_time)
	return result
