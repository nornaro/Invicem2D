@tool
extends CheckBox

@export var mode_shift = 0


func _toggled(button_pressed):
	%Grid.set_grid_mode(%Grid.mode & ~(1 << mode_shift) | (int(button_pressed) << mode_shift))
