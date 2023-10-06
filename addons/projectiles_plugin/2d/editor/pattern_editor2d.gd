@tool
extends Control
class_name PatternEditor2D

const WHEEL_RANGE_INC: float = 5
const WHEEL_SPEED_INC: float = 2
const WHEEL_DELAY_INC: float = 0.01
const SAVE_FILE: String = "projectiles_plugin.txt"

var editor_interface: EditorInterface
var edited_pattern: Pattern2D
var selected_elems: Array[int] = []
var is_edited_in_inspector: bool = false
var keybindings: Dictionary = {}


func _ready() -> void:
	load_editor_state()
	editor_interface.get_inspector().connect("property_edited", _on_inspector_property_edited)
	editor_interface.get_inspector().connect("edited_object_changed", _on_inspector_object_changed)


func _on_inspector_object_changed() -> void:
	is_edited_in_inspector = false


func _on_inspector_property_edited(prop: String) -> void:
	if not is_edited_in_inspector:
		return
	if not edited_pattern or not edited_pattern.data.size() or not prop in edited_pattern.data[0]:
		return
	if not selected_elems.size():
		return
	
	var reference_elem: PatternElem2D = edited_pattern.data[selected_elems.back()]
	for e in selected_elems:
		edited_pattern.data[e].set(prop, reference_elem.get(prop))
		%PatternElements.update_element(e, edited_pattern.data[e])


func save_editor_state() -> void:
	var data: Dictionary = {}
	data["grid"] = %Grid.get_serialized_state()
	var file = FileAccess.open("user://%s" % SAVE_FILE, FileAccess.WRITE)
	file.store_line(JSON.stringify(data))
	file.close()


func load_editor_state() -> void:
	if not FileAccess.file_exists("user://%s" % SAVE_FILE):
		return
	var file = FileAccess.open("user://%s" % SAVE_FILE, FileAccess.READ)
	var json = JSON.new()
	var parsing_state: Error = json.parse(file.get_line())
	if parsing_state != OK:
		return
	var state: Dictionary = json.get_data()
	%Grid.load_state(state["grid"])


func open_pattern_inspector() -> void:
	if edited_pattern:
		editor_interface.edit_resource(edited_pattern)


func open_elem_inspector() -> void:
	if edited_pattern and selected_elems.size() and selected_elems.back() in range(0, edited_pattern.data.size()):
		var inspected_elem: PatternElem2D = edited_pattern.data[selected_elems.back()]
		editor_interface.edit_resource(inspected_elem)
		is_edited_in_inspector = true


func reload() -> void:
	load_pattern(edited_pattern)


func load_pattern(pattern: Pattern2D) -> void:
	if !pattern:
		return
	var is_new: bool = pattern != edited_pattern
	
	if is_new:
		if edited_pattern and edited_pattern.is_connected("changed", _on_edited_pattern_changed):
			edited_pattern.disconnect("changed", _on_edited_pattern_changed)
		edited_pattern = pattern
		selected_elems = []
		
		edited_pattern.connect("changed", _on_edited_pattern_changed)
		%PatternElements.draw_resource(edited_pattern, selected_elems)


func _on_edited_pattern_changed() -> void:
	%PatternElements.draw_resource(edited_pattern, selected_elems)


func deselect_elements() -> void:
	selected_elems = []
	%PatternElements.mark_all_selected(selected_elems)
	if edited_pattern and edited_pattern.data.size() == 0:
		open_pattern_inspector()


func select_all() -> void:
	#TODO: why simply selected_elems = range(edited_pattern.data.size()) doesnt work
	selected_elems = []
	for i in range(edited_pattern.data.size()):
		selected_elems.append(i)
	%PatternElements.mark_all_selected(selected_elems)


func select_elements(elems_i: Array[int]) -> void:
	for i in range(edited_pattern.data.size()):
		if i in elems_i:
			selected_elems.append(i)
			%PatternElements.mark_selected(i)
		elif not i in selected_elems:
			selected_elems.erase(i)
			%PatternElements.mark_unselected(i)
	open_elem_inspector()


func move_elems(pos: Vector2) -> void:
	var relative_pos: Array[Vector2] = []
	for s in selected_elems:
		relative_pos.append(edited_pattern.data[s].position - edited_pattern.data[selected_elems.back()].position)
	for i in range(selected_elems.size()):
		if not selected_elems[i] in range(0, edited_pattern.data.size()):
			continue
		edited_pattern.data[selected_elems[i]].position = pos + relative_pos[i]
		%PatternElements.update_element(selected_elems[i], edited_pattern.data[selected_elems[i]])


func rotate_elems(delta_to_origin: Vector2) -> void:
	for s in selected_elems:
		if not s in range(0, edited_pattern.data.size()):
			continue
		var delta_pos: Vector2 = delta_to_origin - edited_pattern.data[s].position
		var value: float  = rad_to_deg(Vector2(1, 0).angle_to(delta_pos))
		value = %Grid.snap_angle(value)
		edited_pattern.data[s].angle = value
		%PatternElements.update_element(s, edited_pattern.data[s])


func display_range() -> void:
	%PatternElements.display_details("range", "range", edited_pattern, selected_elems)


func modify_range(increase: bool, mod_scale: float) -> void:
	if selected_elems.size() == 0:
		return
	var base_val: float = edited_pattern.data[selected_elems[0]].range
	
	if increase:
		base_val += WHEEL_RANGE_INC*mod_scale
	else:
		base_val = max(0.0, base_val - WHEEL_RANGE_INC*mod_scale)
	
	for i in selected_elems:
		edited_pattern.data[i].range = base_val
	
	%PatternElements.display_details("range", "range", edited_pattern, selected_elems)


func display_speed() -> void:
	%PatternElements.display_details("speed", "speed", edited_pattern, selected_elems)


func modify_speed(increase: bool, mod_scale: float) -> void:
	if selected_elems.size() == 0:
		return
	var base_val: float = edited_pattern.data[selected_elems[0]].speed
	
	if increase:
		base_val += WHEEL_SPEED_INC*mod_scale
	else:
		base_val = max(0.0, base_val - WHEEL_SPEED_INC*mod_scale)
	
	for i in selected_elems:
		edited_pattern.data[i].speed = base_val
	
	%PatternElements.display_details("speed", "speed", edited_pattern, selected_elems)


func display_t_delay() -> void:
	%PatternElements.display_details("t-delay", "travel_delay", edited_pattern, selected_elems)


func modify_t_delay(increase: bool, mod_scale: float) -> void:
	if selected_elems.size() == 0:
		return
	var base_val: float = edited_pattern.data[selected_elems[0]].travel_delay
	
	if increase:
		base_val += WHEEL_DELAY_INC*mod_scale
	else:
		base_val = max(0.0, base_val - WHEEL_DELAY_INC*mod_scale)
	
	for i in selected_elems:
		edited_pattern.data[i].travel_delay = base_val
	
	%PatternElements.display_details("t-delay", "travel_delay", edited_pattern, selected_elems)


func display_s_delay() -> void:
	%PatternElements.display_details("delay", "spawn_delay", edited_pattern, selected_elems)


func modify_s_delay(increase: bool, mod_scale: float) -> void:
	if selected_elems.size() == 0:
		return
	var base_val: float = edited_pattern.data[selected_elems[0]].spawn_delay
	
	if increase:
		base_val += WHEEL_DELAY_INC*mod_scale
	else:
		base_val = max(0.0, base_val - WHEEL_DELAY_INC*mod_scale)
	
	for i in selected_elems:
		edited_pattern.data[i].spawn_delay = base_val
	
	%PatternElements.display_details("delay", "spawn_delay", edited_pattern, selected_elems)


func hide_elems_details() -> void:
	%PatternElements.hide_elems_details()

func rotate_inwards() -> void:
	for i in selected_elems:
		edited_pattern.data[i].angle = rad_to_deg(Vector2(1, 0).angle_to(edited_pattern.data[i].position))
		%PatternElements.update_element(i, edited_pattern.data[i])


func rotate_outwards() -> void:
	for i in selected_elems:
		edited_pattern.data[i].angle = rad_to_deg(Vector2(1, 0).angle_to(-edited_pattern.data[i].position))
		%PatternElements.update_element(i, edited_pattern.data[i])


func rotate_parallel(delta_from_origin: Vector2) -> void:
	for i in selected_elems:
		edited_pattern.data[i].angle = rad_to_deg(Vector2(1, 0).angle_to(delta_from_origin))
		%PatternElements.update_element(i, edited_pattern.data[i])


func rotate_focused(delta_from_origin: Vector2) -> void:
	for i in selected_elems:
		var d: Vector2 = delta_from_origin - edited_pattern.data[i].position
		edited_pattern.data[i].angle = rad_to_deg(Vector2(1, 0).angle_to(d))
		%PatternElements.update_element(i, edited_pattern.data[i])


func rotate_all_random() -> void:
	for i in selected_elems:
		edited_pattern.data[i].angle = randf()*360.0
		%PatternElements.update_element(i, edited_pattern.data[i])


func duplicate_elem() -> void:
	if not (selected_elems.size() > 0 and selected_elems[0] in range(edited_pattern.data.size())):
		return
	
	var new_elem: PatternElem2D = edited_pattern.data[selected_elems[0]].duplicate(true)
	new_elem.projectile = edited_pattern.data[selected_elems[0]].projectile
	edited_pattern.data.append(new_elem)
	selected_elems = [edited_pattern.data.size() - 1]
	%PatternElements.draw_resource(edited_pattern, selected_elems)


func remove_elems() -> void:
	if !edited_pattern:
		return
	var elems_left: Array[PatternElem2D] = []
	for i in range(0, edited_pattern.data.size()):
		if not i in selected_elems:
			elems_left.append(edited_pattern.data[i])
	edited_pattern.data = elems_left
	selected_elems = []
	%PatternElements.draw_resource(edited_pattern, selected_elems)


func run_simulation() -> void:
	%PatternShooter.pattern = edited_pattern
	%PatternShooter.fire_pattern()


func clear_simulation() -> void:
	%PatternShooter.clear()


func get_keybindings() -> Dictionary:
	return keybindings
