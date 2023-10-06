@tool
extends Trajectory2D
class_name ZigzagTrajectory2D

@export_enum("sin", "line") var type = "sin"
@export var amplitude: float = 100.0
@export var phase_shift: float = 0.0
@export var angle_deg: float = 0.0
@export var cycle_time: float = 1.0


func get_delta(delta: float, total_time: float) -> Vector2:
	var angle_rad: float = deg_to_rad(angle_deg)
	var phase_shift_rad: float = deg_to_rad(phase_shift)
	if type == "sin":
		var curr_time: float = total_time/cycle_time/2.0*PI + phase_shift_rad
		var prev_time: float = curr_time - delta/cycle_time/2.0*PI
		return amplitude*Vector2(sin(curr_time) - sin(prev_time), 0.0).rotated(angle_rad)
	else:
		var curr_time: float = total_time/cycle_time + phase_shift_rad
		var prev_time: float = curr_time - delta/cycle_time
		var curr: float = 0.5 + abs(0.5 - curr_time + floor(curr_time))
		var prev: float = 0.5 + abs(0.5 - prev_time + floor(prev_time))
		return amplitude*Vector2(curr - prev, 0.0).rotated(angle_rad)

