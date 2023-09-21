extends Node

@onready var UI = %UI
@onready var BuildArea = $"../Map/Area"
@onready var Placement = $"../Placement"
@onready var Ground = $"../Map/Ground"

# 2DO Placement grid?

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
		selected_building.clear()
		if instance:
			instance.queue_free()
			instance = null
		%UI.clear()
	if event.is_action_pressed("LMB"):
		build = true
	if event.is_action_released("LMB"):
		build = false
	if not instance:
		return
	instance.position = snap(Ground.get_local_mouse_position())
	if Placement.overlapping.has(instance.get_instance_id()):
		if !Placement.overlapping[instance.get_instance_id()].is_empty():
			instance.modulate = collision_color
			instance.get_node("Select").color = "red"
			return
	instance.modulate = placement_color
	if !build:
		return
	instance.modulate = normal_color
	instance.temp = false
	instance_scene_from_name(instance.get_parent().name)
		
func is_point_in_mesh_bounds(mesh: MeshInstance2D, point: Vector2) -> bool:
	var mesh_extents = mesh.mesh.get_aabb().size / 2
	var mesh_extents_2d = Vector2(mesh_extents.x, mesh_extents.y) * mesh.scale
	var min_point = mesh.global_position - mesh_extents_2d
	var max_point = mesh.global_position + mesh_extents_2d

	return point.x > min_point.x and point.x < max_point.x and point.y > min_point.y and point.y < max_point.y

func instance_scene_from_name(scene_name: String):
	var old_id
	if instance:
		old_id = instance.get_instance_id()
	var scene = load("res://buildings/" + scene_name + ".tscn")
	instance = scene.instantiate()
	if old_id:
		Placement.overlapping[instance.get_instance_id()] = {old_id:null}
	instance.position = snap(Ground.get_local_mouse_position())
	instance.temp = true
	instance.modulate = placement_color
	instance.get_node("Select").color = "green"
	get_node(scene_name).add_child(instance)
	instance.add_child(load("res://id.tscn").instantiate())
	return instance.get_instance_id()

func _process(_delta):
	pass
	
func snap(position: Vector2) -> Vector2:
	var x = round(position.x / 25.0) * 25
	var y = round(position.y / 25.0) * 25
	
	x = clamp(x, -750, 750)
	if y <= 0:
		y = clamp(y, -450, -150)
	if y >= 0:
		y = clamp(y, 125, 425)
	
	return Vector2(x, y)
