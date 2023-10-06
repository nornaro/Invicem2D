@tool
extends CheckBox

func _pressed() -> void:
	%Grid.set_snapping(button_pressed)
