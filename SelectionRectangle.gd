extends Area2D

var start_position: Vector2 = Vector2.ZERO
var dragging: bool = false
var selected

func _input(event):
	if get_tree().get_nodes_in_group("temp"):
		return
	if event.is_action_pressed("LMB"):
		start_position = get_global_mouse_position()
		dragging = true
	if event.is_action_released("LMB"):
		dragging = false
		$CollisionShape2D.hide()
		$CollisionShape2D.position = Vector2.ZERO
		$CollisionShape2D.shape.extents = Vector2.ZERO
	if event is InputEventMouseMotion:
		if !dragging:
			return
		
		# Current mouse position
		var end_position = get_global_mouse_position()
		
		# Determine top-left and size
		var top_left = get_min_vector(start_position, end_position)
		var size = get_size_vector(start_position, end_position)
		if size.length() < 100:
			return
		$CollisionShape2D.show()
		# Set position and size for the CollisionShape2D (assuming you have a RectangleShape2D as its shape)
		var collision_shape = $CollisionShape2D
		collision_shape.position = top_left + size * 0.5
		collision_shape.shape.extents = size * 0.5

func get_min_vector(v1: Vector2, v2: Vector2) -> Vector2:
	return Vector2(min(v1.x, v2.x), min(v1.y, v2.y))

func get_size_vector(v1: Vector2, v2: Vector2) -> Vector2:
	return Vector2(abs(v1.x - v2.x), abs(v1.y - v2.y))

func _on_area_entered(area):
	if !area.is_in_group("building"):
		return
	area.multiselect = true
	area.set_selected(!area.selected)

func _on_area_exited(area):
	if !area.is_in_group("building"):
		return
	if !dragging:
		return
	area.multiselect = true
	area.set_selected(!area.selected)
