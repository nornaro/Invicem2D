@tool
extends SpinBox


func _value_changed(v) -> void:
	if v == 0:
		return
	%Grid.set_grid_angle_step(v)
