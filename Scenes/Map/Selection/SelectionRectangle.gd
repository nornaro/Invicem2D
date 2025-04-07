extends Area2D

var start_position: Vector2 = Vector2.ZERO
var dragging: bool = false
var selected:bool = false
var border:int = 10
@onready var collision:CollisionShape2D = $Collision
@onready var fill:Node = $Fill

func _ready() -> void:
	connect("area_entered",_on_area_entered)
	connect("area_exited",_on_area_exited)

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		cancel_selection()
	if get_tree().get_nodes_in_group("temp"):
		return
	if event.is_action_pressed("LMB"):
		start_position = get_global_mouse_position()
		dragging = true
	if event.is_action_released("LMB"):
		dragging = false
		finish_selection()
	if event is InputEventMouseMotion:
		if !dragging:
			return
		var end_position:Vector2 = get_global_mouse_position()
		var top_left:Vector2 = get_min_vector(start_position, end_position)
		var size:Vector2 = get_size_vector(start_position, end_position)
		start_selection(top_left,size)
		if size.length() < 100:
			return
		
func cancel_selection():
	#get_tree().call_group("SelectionRectangle", "hide")
	get_tree().call_group("BuildingArea","set_selected",false)
	
func finish_selection() -> void:
	hide()
	fill.size = Vector2.ZERO
	collision.position = Vector2.ZERO
	collision.shape.extents = Vector2.ZERO

func start_selection(top_left:Vector2,size:Vector2) -> void:
		show()
		collision.position = top_left + size * 0.5
		collision.shape.extents = size * 0.5
		fill.position = top_left
		fill.size = size

func get_min_vector(v1: Vector2, v2: Vector2) -> Vector2:
	return Vector2(min(v1.x, v2.x), min(v1.y, v2.y))

func get_size_vector(v1: Vector2, v2: Vector2) -> Vector2:
	return Vector2(abs(v1.x - v2.x), abs(v1.y - v2.y))

func _on_area_entered(area:Area2D) -> void:
	if !area.is_in_group("building"):
		return
	area.multiselect = true
	area.set_selected(!area.selected)

func _on_area_exited(area:Area2D) -> void:
	if !area.is_in_group("building"):
		return
	if !dragging:
		return
	area.multiselect = true
	area.set_selected(!area.selected)
