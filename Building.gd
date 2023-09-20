extends Node2D

@onready var UI = %UI
@onready var BuildArea = $"../Map/Area"
@export var property_list = false

var instance
var build = false
var normal_color: Color = Color(1, 1, 1, 1) # original color
var placement_color: Color = Color(1, 1, 1, 0.5) # original color
var collision_color: Color = Color(1, 0.5, 0.5, 0.5) # reddish color
var building_to_build
var selected_building = []
var placement = false

func _input(event):	
	if event.is_action_pressed("RMB"):
		if instance:
			instance.queue_free()
			instance = null
	if event.is_action_pressed("LMB"):
		build = true
	if event.is_action_released("LMB"):
		build = false
		
func is_point_in_mesh_bounds(mesh: MeshInstance2D, point: Vector2) -> bool:
	var mesh_extents = mesh.mesh.get_aabb().size / 2
	var mesh_extents_2d = Vector2(mesh_extents.x, mesh_extents.y) * mesh.scale
	var min_point = mesh.global_position - mesh_extents_2d
	var max_point = mesh.global_position + mesh_extents_2d

	return point.x > min_point.x and point.x < max_point.x and point.y > min_point.y and point.y < max_point.y
	
func _on_item_list_item_selected(index):
	building_to_build = UI.get_node("BuildingList").get_item_text(index)
	instance_scene_from_name(building_to_build)

func instance_scene_from_name(scene_name: String):
	var scene_path = "res://buildings/" + scene_name + ".tscn"
	var old_overlap
	if instance:
		instance.modulate = normal_color
		instance.temp = false
		old_overlap = instance.get_node("Area2D")
	%UI.clear()
	if !ResourceLoader.exists(scene_path):
		print("Scene does not exist:", scene_path)
	var scene = load(scene_path)
	instance = scene.instantiate()
	$"../Placement".overlapping[instance.get_instance_id()] = []
	instance.position = get_snap_to_hundred($"../Map/Ground".get_local_mouse_position())
	instance.temp = true
	instance.modulate = placement_color
	get_node(scene_name).add_child(instance)
	if old_overlap:
		instance.get_node("Area2D")._on_area_entered(old_overlap)
		old_overlap._on_area_entered(instance.get_node("Area2D"))
	instance.add_child(load("res://id.tscn").instantiate())

func _process(_delta):
	if not instance:
		return
	instance.position = get_snap_to_hundred($"../Map/Ground".get_local_mouse_position())
	if !$"../Placement".overlapping[instance.get_instance_id()].is_empty():
		return
	if build:
		instance_scene_from_name(building_to_build)
	
func get_snap_to_hundred(position: Vector2) -> Vector2:
	var x = round(position.x / 25.0) * 25
	var y = round(position.y / 25.0) * 25
	
	x = clamp(x, -750, 750)
	if y <= 0:
		y = clamp(y, -450, -150)
	if y >= 0:
		y = clamp(y, 125, 425)
	
	return Vector2(x, y)
