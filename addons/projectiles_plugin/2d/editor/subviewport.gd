@tool
extends SubViewportContainer

enum WorkMode {
	DEFAULT,
	POSITION,
	ROTATION,
	ROTATION_PARALLEL,
	ROTATION_FOCUSED,
	MODIFY_SPEED,
	MODIFY_RANGE,
	MODIFY_S_DELAY,
	MODIFY_T_DELAY,
	RECT_SELECT,
}

@export var drag_dist_disable_click: float = 30.0
@export var zoom_min: float = 0.5
@export var zoom_max: float = 4.0

var prev_pressed_mouse: bool = false
var work_mode: WorkMode = WorkMode.DEFAULT
var ctrl_pressed: bool = false
var shift_pressed: bool = false
var alt_pressed: bool = false
var prev_size: Vector2 = Vector2(0.0, 0.0)


func _ready() -> void:
	connect("resized", _on_resized)


func _on_resized() -> void:
	if abs(prev_size.x - size.x) >= 100.0:
		%CustomCamera.position = size/2.0
	else:
		%CustomCamera.position += (size - prev_size)/2.0
	%Grid.set_grid_offset(%CustomCamera.position)
	prev_size = size


#TODO: needs overhaul
func _gui_input(event):
	if event is InputEventKey and event.keycode == KEY_CTRL:
		ctrl_pressed = event.pressed
	elif event is InputEventKey and event.keycode == KEY_SHIFT:
		shift_pressed = event.pressed
	elif event is InputEventKey and event.keycode == KEY_ALT:
		alt_pressed = event.pressed
	elif event is InputEventKey and event.pressed and not event.is_echo():
		if event.keycode in owner.get_keybindings().keys():
			handle_action(owner.get_keybindings()[event.keycode])
			accept_event()
		else:
			handle_action("none")
	elif event is InputEventMouseButton and event.button_index in [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_RIGHT]:
		handle_action("none")
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			%Grid.set_select_beg(to_world_pos(event.position))
			work_mode = WorkMode.RECT_SELECT
		elif work_mode == WorkMode.RECT_SELECT:
			var select_area: Rect2 = %Grid.get_select_area()
			var selected_elems: Array[int] = %PatternElements.try_select(select_area)
			if not ctrl_pressed:
				owner.deselect_elements()
			if selected_elems.size():
				owner.select_elements(selected_elems)
			%Grid.hide_selection()
			work_mode = WorkMode.DEFAULT
	
	if event is InputEventMouseMotion and work_mode == WorkMode.RECT_SELECT:
		%Grid.set_select_end(to_world_pos(event.position))
	
	if work_mode == WorkMode.DEFAULT and event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
		%CustomCamera.position += event.relative
		%Grid.set_grid_offset(%CustomCamera.position)
	if work_mode in [WorkMode.ROTATION, WorkMode.ROTATION_FOCUSED, WorkMode.ROTATION_PARALLEL] and (event is InputEventMouseMotion or event is InputEventMouseButton):
		var delta_pos: Vector2 = to_world_pos(event.position) - %PatternDisplay.position
		if work_mode == WorkMode.ROTATION:
			owner.rotate_elems(delta_pos)
		elif work_mode == WorkMode.ROTATION_PARALLEL:
			owner.rotate_parallel(delta_pos)
		elif work_mode == WorkMode.ROTATION_FOCUSED:
			owner.rotate_focused(delta_pos)
	if work_mode == WorkMode.POSITION and (event is InputEventMouseMotion or event is InputEventMouseButton):
		var target_pos: Vector2 = to_world_pos(event.position) - %PatternDisplay.position
		target_pos = %Grid.snap(target_pos)
		owner.move_elems(target_pos)
	if event is InputEventMouseButton and event.button_index in [MOUSE_BUTTON_WHEEL_DOWN, MOUSE_BUTTON_WHEEL_UP]:
		var mod_scale: float = 1.0
		if alt_pressed:
			mod_scale *= 10.0
		if shift_pressed:
			mod_scale /= 10.0
		if work_mode == WorkMode.MODIFY_RANGE:
			owner.modify_range(event.button_index == MOUSE_BUTTON_WHEEL_UP, mod_scale)
		elif work_mode == WorkMode.MODIFY_SPEED:
			owner.modify_speed(event.button_index == MOUSE_BUTTON_WHEEL_UP, mod_scale)
		elif work_mode == WorkMode.MODIFY_T_DELAY:
			owner.modify_t_delay(event.button_index == MOUSE_BUTTON_WHEEL_UP, mod_scale)
		elif work_mode == WorkMode.MODIFY_S_DELAY:
			owner.modify_s_delay(event.button_index == MOUSE_BUTTON_WHEEL_UP, mod_scale)
		elif ctrl_pressed:
			var new_zoom: float = %CustomCamera.get_zoom()
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				new_zoom += 0.1
			else:
				new_zoom -= 0.1
			new_zoom = min(zoom_max, max(zoom_min, new_zoom))
			%CustomCamera.set_zoom(new_zoom)
			%Grid.set_zoom(new_zoom)


func handle_action(action_name: String) -> void:
	if action_name == "move_elem":
		work_mode = WorkMode.POSITION
	elif action_name == "rotate_elem":
		work_mode = WorkMode.ROTATION
	elif action_name == "toggle_snapping":
		%Grid.toggle_snapping()
	elif action_name == "test_pattern":
		owner.run_simulation()
	elif action_name == "rotate_inwards":
		owner.rotate_inwards()
	elif action_name == "rotate_outwards":
		owner.rotate_outwards()
	elif action_name == "rotate_parallel":
		work_mode = WorkMode.ROTATION_PARALLEL
	elif action_name == "rotate_focused":
		work_mode = WorkMode.ROTATION_FOCUSED
	elif action_name == "select_all":
		owner.select_all()
	elif action_name == "duplicate_elem":
		owner.duplicate_elem()
		work_mode = WorkMode.POSITION
	elif action_name == "remove_elems":
		owner.remove_elems()
	elif action_name == "modify_s_delay":
		work_mode = WorkMode.MODIFY_S_DELAY
		owner.display_s_delay()
	elif action_name == "modify_t_delay":
		work_mode = WorkMode.MODIFY_T_DELAY
		owner.display_t_delay()
	elif action_name == "modify_speed":
		work_mode = WorkMode.MODIFY_SPEED
		owner.display_speed()
	elif action_name == "modify_range":
		work_mode = WorkMode.MODIFY_RANGE
		owner.display_range()
	elif work_mode != WorkMode.RECT_SELECT:
		work_mode = WorkMode.DEFAULT
	
	if not work_mode in [WorkMode.MODIFY_RANGE, WorkMode.MODIFY_SPEED, WorkMode.MODIFY_T_DELAY, WorkMode.MODIFY_S_DELAY]:
		owner.hide_elems_details()


func to_world_pos(pos: Vector2) -> Vector2:
	var offset: Vector2 = get_child(0).canvas_transform.origin
	var zoom: float = %CustomCamera.get_zoom()
	var res: Vector2 = (pos - offset)/zoom
	return res
