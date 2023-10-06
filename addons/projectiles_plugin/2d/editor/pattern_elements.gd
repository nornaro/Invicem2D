@tool
extends Node2D

@export var elem_display_scene: PackedScene
@export var select_area: float = 20.0


func draw_resource(edited_pattern: Pattern2D, selected_elems: Array[int]) -> void:
	while get_child_count() > edited_pattern.data.size():
		get_child(get_child_count() - 1).free()
	
	for i in range(0, edited_pattern.data.size()):
		if i < get_child_count():
			get_child(i).set_index(i)
		else:
			var elem_display: Node2D = elem_display_scene.instantiate()
			elem_display.set_index(i)
			%PatternElements.add_child(elem_display)
		update_element(i, edited_pattern.data[i])
	
	mark_all_selected(selected_elems)


func update_element(elem_i: int, elem: PatternElem2D) -> void:
	if !elem:
		return
	for c in get_children():
		if c.get_elem_index() == elem_i:
			c.set_index(elem_i)
			c.set_elem_rotation(elem.angle)
			c.position = elem.position
			
			return


func reorder_child_to_last(child: Node2D) -> void:
	move_child(child, -1)


func try_select(area: Rect2) -> Array[int]:
	area = area.abs()
	if (area.end - area.position).length() < 12.0:
		for c in get_children():
			if (c.global_position - area.end).length() <= select_area*%CustomCamera.get_zoom():
				return [c.get_elem_index()]
	else:
		var elems_in_area: Array[int] = []
		for c in get_children():
			if area.has_point(c.global_position):
				elems_in_area.append(c.get_elem_index())
		return elems_in_area
	return []


func mark_selected(selected_i: int) -> void:
	for i in range(0, get_child_count()):
		if get_child(i).get_elem_index() == selected_i:
			get_child(i).set_focus(true)
			reorder_child_to_last(get_child(i))
			break


func mark_unselected(selected_i: int) -> void:
	for i in range(0, get_child_count()):
		if get_child(i).get_elem_index() == selected_i:
			get_child(i).set_focus(false)
			break


func mark_all_selected(selected_i: Array[int]) -> void:
	for i in range(0, get_child_count()):
		get_child(i).set_focus(get_child(i).get_elem_index() in selected_i)
	
	if selected_i.size() > 0:
		reorder_child_to_last(get_child(selected_i[0]))


func display_details(title: String, property: String, pattern: Pattern2D, selected_elems: Array[int]) -> void:
	for c in get_children():
		if c.get_elem_index() in selected_elems:
			c.display_action(title, pattern.data[c.get_elem_index()].get(property))


func hide_elems_details() -> void:
	for c in get_children():
		c.hide_action()
