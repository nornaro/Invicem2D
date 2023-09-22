extends Node

@onready var Ground = $"../Map/Ground"
var overlapping

# 2DO Placement grid?

var build = false
var normal_color: Color = Color(1, 1, 1, 1) # original color
var placement_color: Color = Color(1, 1, 1, 0.5) # original color
var collision_color: Color = Color(1, 0.5, 0.5, 0.5) # reddish color
var temp_instance
var placement = false

func _ready():
	load_directory_data("res://Scenes/Buildings/Building/")
	if $"../Placement": overlapping = $"../Placement".overlapping
	for child in get_children():
		child._ready()

func load_directory_data(dir):
	var directory = DirAccess.open(dir)
	if not directory:
		return
	add_buildings_list(buildings_list(directory))
	
func buildings_list(directory):
	directory.list_dir_begin()  # skip navigation entries
	var list = []
	for file_name in directory.get_files():
		if file_name.ends_with(".png"):
			list.append(file_name.replace(".png", ""))
	return list
		
func add_buildings_list(list):
	for buildings in list:
		var scene = load("res://Scenes/Buildings/type.tscn")
		var instance = scene.instantiate()
		instance.name = buildings
		add_child(instance)
		var script = "res://Scenes/Buildings/"+buildings+"s.gd"
		print(instance.get_script())
		FileAccess.file_exists(script)
		if FileAccess.file_exists(script):
			instance.set_script(load(script))
			print(instance.get_script())

func _input(event):	
	if event.is_action_pressed("RMB"):
		if temp_instance:
			temp_instance.queue_free()
			temp_instance = null
	if event.is_action_pressed("LMB"):
		build = true
	if event.is_action_released("LMB"):
		build = false
	if not temp_instance:
		return
	temp_instance.position = snap(Ground.get_local_mouse_position())
	if $"../Placement":
		if !placeable():
			return
	temp_instance.modulate = placement_color
	if !build:
		return
	temp_instance.modulate = normal_color
	instance_scene_from_name(temp_instance.get_parent().name)

func placeable():
	if overlapping.has(temp_instance.get_instance_id()):
		if !overlapping[temp_instance.get_instance_id()].is_empty():
			temp_instance.modulate = collision_color
			temp_instance.get_node("Select").color = "red"
			return false
	return true

func is_point_in_mesh_bounds(mesh: MeshInstance2D, point: Vector2) -> bool:
	var mesh_extents = mesh.mesh.get_aabb().size / 2
	var mesh_extents_2d = Vector2(mesh_extents.x, mesh_extents.y) * mesh.scale
	var min_point = mesh.global_position - mesh_extents_2d
	var max_point = mesh.global_position + mesh_extents_2d

	return point.x > min_point.x and point.x < max_point.x and point.y > min_point.y and point.y < max_point.y

func instance_scene_from_name(scene_name: String):
	var old_id
	if temp_instance:
		old_id = temp_instance.get_instance_id()
	var scene = load("res://Scenes/Buildings/Building/building.tscn")
	temp_instance = scene.instantiate()
	if old_id && overlapping:
		overlapping[temp_instance.get_instance_id()] = {old_id:null}
	temp_instance.position = snap(Ground.get_local_mouse_position())
	temp_instance.modulate = placement_color
	temp_instance.get_node("Select").color = "green"
	get_node(scene_name).add_child(temp_instance)
	temp_instance.add_child(load("res://Scenes/Buildings/id.tscn").instantiate())
	return temp_instance.get_instance_id()

func snap(position: Vector2) -> Vector2:
	var x = round(position.x / 25.0) * 25
	var y = round(position.y / 25.0) * 25
	
	x = clamp(x, -750, 750)
	if y <= 0:
		y = clamp(y, -450, -150)
	if y >= 0:
		y = clamp(y, 125, 425)
	
	return Vector2(x, y)
