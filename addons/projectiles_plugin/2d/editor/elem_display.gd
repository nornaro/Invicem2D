@tool
extends Sprite2D

@export var color_normal: Color
@export var color_focused: Color
@export var scale_focused: float = 1.4

var index: int = 0
var action_t: float = 0.0


func set_index(i: int) -> void:
	index = i
	%ElemNumber.text = str(index)


func set_elem_rotation(r: float) -> void:
	$DirectionDisplay.rotation_degrees = r


func get_elem_index() -> int:
	return index


func set_focus(is_focused: bool) -> void:
	if is_focused:
		modulate = color_focused
		scale = Vector2(scale_focused, scale_focused)
		%ElemNumber.show()
	else:
		modulate = color_normal
		scale = Vector2(1, 1)
		%ElemNumber.hide()


func display_action(action_name: String, value: float) -> void:
	%DetailsDisplay.text = "%s: %s" % [action_name, value]
	%DetailsDisplay.show()


func hide_action() -> void:
	%DetailsDisplay.hide()
