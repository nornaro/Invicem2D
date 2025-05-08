extends Area2D

var start_position: Vector2 = Vector2.ZERO
var dragging: bool = false
var selected:bool = false
var border:int = 10

func _ready() -> void:
	connect("area_entered",_on_area_entered)
	connect("area_exited",_on_area_exited)

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().call_group("Outline", "hide")
		for node in get_tree().get_nodes_in_group("selected"):
			node.set_selected(false)
	if get_tree().get_nodes_in_group("temp"):
		return
	if event.is_action_pressed("LMB"):
		start_position = get_global_mouse_position()
		dragging = true
	if event.is_action_released("LMB"):
		dragging = false
		$Fill.hide()
		$Fill.size = Vector2.ZERO
		$CollisionShape2D.position = Vector2.ZERO
		$CollisionShape2D.shape.extents = Vector2.ZERO
	if event is InputEventMouseMotion:
		if !dragging:
			return
		var end_position:Vector2 = get_global_mouse_position()
		var top_left:Vector2 = get_min_vector(start_position, end_position)
		var size:Vector2 = get_size_vector(start_position, end_position)
		if size.length() < 100:
			return
		$CollisionShape2D.show()
		var collision_shape:CollisionShape2D = $CollisionShape2D
		collision_shape.position = top_left + size * 0.5
		collision_shape.shape.extents = size * 0.5
		$Fill.show()
		$Fill.position = top_left
		$Fill.size = size

func get_min_vector(v1: Vector2, v2: Vector2) -> Vector2:
	return Vector2(min(v1.x, v2.x), min(v1.y, v2.y))

func get_size_vector(v1: Vector2, v2: Vector2) -> Vector2:
	return Vector2(abs(v1.x - v2.x), abs(v1.y - v2.y))

func _on_area_entered(area:Area2D) -> void:
	if area is not BuildingArea:
		return
	area.multiselect = true
	area.set_selected(!area.selected)

func _on_area_exited(area:Area2D) -> void:
	if area is not BuildingArea:
		return
	if !dragging:
		return
	area.multiselect = true
	area.set_selected(!area.selected)
