@tool
extends TextureRect

@export var use_snapping: bool = false
@export var mode: int = 0x03
@export var grid_size: Vector2 = Vector2(32, 32)
@export var angle_step: float = 45.0
@export var grid_offset: Vector2 = Vector2(200, 200)
@export var grid_scale: float = 1.0

var select_beg: Vector2 = Vector2(0.0, 0.0)
var select_end: Vector2 = Vector2(0.0, 0.0)


func _ready() -> void:
	update_shader_params()


func get_serialized_state() -> Dictionary:
	return {
		"use_snapping": use_snapping,
		"mode": mode,
		"grid_size": grid_size,
		"angle_step": angle_step,
	}


func load_state(state: Dictionary) -> void:
	for prop in state.keys():
		set(prop, state[prop])
	update_shader_params()
	%GridXCheckbox.button_pressed = (mode & (1 << 0)) != 0
	%GridYCheckbox.button_pressed = (mode & (1 << 1)) != 0
	%GridCircularCheckbox.button_pressed = (mode & (1 << 2)) != 0
	%GridRadialCheckbox.button_pressed = (mode & (1 << 3)) != 0
	%GridXValue.value = grid_size.x
	%GridYValue.value = grid_size.y
	%GridAngleValue.value = angle_step
	%GridSnapCheckbox.button_pressed = use_snapping


func set_grid_offset(value: Vector2) -> void:
	grid_offset = value
	update_shader_params()
	owner.save_editor_state()


func set_grid_mode(value: int) -> void:
	mode = value
	update_shader_params()
	owner.save_editor_state()


func set_grid_size_x(value: int) -> void:
	grid_size.x = value
	update_shader_params()
	owner.save_editor_state()


func set_grid_size_y(value: int) -> void:
	grid_size.y = value
	update_shader_params()
	owner.save_editor_state()


func set_grid_angle_step(value: float) -> void:
	angle_step = value
	update_shader_params()
	owner.save_editor_state()


func set_zoom(value: float) -> void:
	grid_scale = 1.0/value
	update_shader_params()
	owner.save_editor_state()


func update_shader_params() -> void:
	material.set("shader_parameter/grid_x", grid_size.x)
	material.set("shader_parameter/grid_y", grid_size.y)
	material.set("shader_parameter/offset", grid_offset)
	material.set("shader_parameter/draw_mode", mode)
	material.set("shader_parameter/angle_step", angle_step)
	material.set("shader_parameter/scale", grid_scale)
	if (select_end - select_beg).length() > 12.0:
		var beg: Vector2 = Vector2(min(select_beg.x, select_end.x), min(select_beg.y, select_end.y))
		var end: Vector2 = Vector2(max(select_beg.x, select_end.x), max(select_beg.y, select_end.y))
		material.set("shader_parameter/select_beg", beg)
		material.set("shader_parameter/select_end", end)
	else:
		material.set("shader_parameter/select_beg", Vector2(0.0, 0.0))
		material.set("shader_parameter/select_end", Vector2(0.0, 0.0))


func set_snapping(value: bool) -> void:
	use_snapping = value
	owner.save_editor_state()


func toggle_snapping() -> void:
	set_snapping(!use_snapping)
	%GridSnapCheckbox.button_pressed = use_snapping
	owner.save_editor_state()


func snap(pos: Vector2) -> Vector2:
	if !use_snapping:
		return pos
	if mode >> 0 & 1:
		pos = snap_x(pos)
	if mode >> 1 & 1:
		pos = snap_y(pos)
	if mode >> 2 & 1:
		pos = snap_circle(pos)
	if mode >> 3 & 1:
		pos = snap_perimeter(pos)
	return pos


func snap_x(pos: Vector2) -> Vector2:
	pos.x = floor((pos.x + grid_size.x/2.0)/grid_size.x)*grid_size.x
	return pos


func snap_y(pos: Vector2) -> Vector2:
	pos.y = floor((pos.y + grid_size.y/2.0)/grid_size.y)*grid_size.y
	return pos


func snap_circle(pos: Vector2) -> Vector2:
	#TODO: non-square grid sizes
	pos = pos.normalized()*floor((pos.length() + grid_size.x/2.0)/grid_size.x)*grid_size.x
	return pos


func snap_perimeter(pos: Vector2) -> Vector2:
	var rot: float = rad_to_deg(Vector2(1, 0).angle_to(pos))
	rot = floor((rot + angle_step/2.0)/angle_step)*angle_step
	return Vector2(pos.length(), 0).rotated(deg_to_rad(rot))


func snap_angle(angle: float) -> float:
	if !use_snapping or mode >> 3 == 0:
		return angle
	return floor((angle + angle_step/2.0)/angle_step)*angle_step


func set_select_beg(pos: Vector2) -> void:
	select_beg = pos
	select_end = pos


func set_select_end(pos: Vector2) -> void:
	select_end = pos
	update_shader_params()


func hide_selection() -> void:
	select_beg = Vector2(0.0, 0.0)
	select_end = Vector2(0.0, 0.0)
	update_shader_params()


func get_select_area() -> Rect2:
	return Rect2(select_beg, select_end - select_beg)
