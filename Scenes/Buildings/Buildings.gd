extends Node2D

var overlapping
@export var Data = {}

# 2DO Placement grid?

var build = false
var normal_color: Color = Color(1, 1, 1, 1) # original color
var placement_color: Color = Color(1, 1, 1, 0.5) # original color
var collision_color: Color = Color(1, 0.5, 0.5, 0.5) # reddish color
var temp_instance
var placement = false
var drag = false
var rectangle = Area2D.new()

func _ready():
	load_directory_data("res://Scenes/Building/")

func load_directory_data(dir):
	var directory = DirAccess.open(dir)
	if not directory:
		return
	add_buildings_list(buildings_list(directory))
	
func buildings_list(directory):
	directory.list_dir_begin()
	var list = []
	for building in directory.get_directories():
		list.append(building)
	return list
		
func add_buildings_list(list):
	for building in list:
		var instance = Node.new()
		instance.name = building
		add_child(instance)
		
		if building == "Castle":
			build_castle(building)

func _input(event):
	if event.is_action_pressed("RMB"):
		if temp_instance:
			temp_instance.queue_free()
			temp_instance = null
	if event.is_action_pressed("LMB"):
		drag = true
	if event.is_action_released("LMB"):
		drag = false
		rectangle = Area2D.new()
	if event is InputEventMouseMotion:
		if drag:
			selection_rectangle()
	if not temp_instance:
		return
	if event.is_action_pressed("LMB"):
		build = true
	if event.is_action_released("LMB"):
		build = false
	temp_instance.position = snap(get_global_mouse_position())
	var colliding = get_tree().get_nodes_in_group(str(temp_instance.get_node("Area2D").get_instance_id()))
	if colliding:
		temp_instance.modulate = collision_color
		return
	temp_instance.modulate = placement_color
	if !build:
		return
	temp_instance.modulate = normal_color
#	temp_instance.clear_collision()
	load_script_from_name(temp_instance.get_parent().name)
	instance_scene_from_name(temp_instance.get_parent().name)

func selection_rectangle():
	rectangle.add_child(CollisionShape2D.new())
	rectangle.scale += get_local_mouse_position()	

func is_point_in_mesh_bounds(mesh: MeshInstance2D, point: Vector2) -> bool:
	var mesh_extents = mesh.mesh.get_aabb().size / 2
	var mesh_extents_2d = Vector2(mesh_extents.x, mesh_extents.y) * mesh.scale
	var min_point = mesh.global_position - mesh_extents_2d
	var max_point = mesh.global_position + mesh_extents_2d

	return point.x > min_point.x and point.x < max_point.x and point.y > min_point.y and point.y < max_point.y

func instance_scene_from_name(scene_name: String):
	var old_id
	if temp_instance:
		old_id = temp_instance
		old_id.remove_from_group("temp")
	var scene = load("res://Scenes/Building/building.tscn")
	temp_instance = scene.instantiate()
	temp_instance.add_to_group("temp")
	if old_id:
		old_id.get_node("Area2D").add_to_group(str(temp_instance.get_node("Area2D").get_instance_id()))
	temp_instance.position = snap(get_global_mouse_position())
	temp_instance.name = str(temp_instance.get_instance_id())
	temp_instance.modulate = placement_color
	temp_instance.get_node("Select/red").hide()
	temp_instance.get_node("Select/green").show()
	get_node(scene_name).add_child(temp_instance)
		
	return temp_instance.get_instance_id()

func build_castle(scene_name):
	var scene = load("res://Scenes/Building/building.tscn")
	var instance = scene.instantiate()
	instance.name = str(instance.get_instance_id())
	get_node(scene_name).add_child(instance)
	instance.modulate = normal_color
	instance.mesh.center_offset.y = 100
	scene = load("res://Scenes/Building/"+scene_name+"/health_bar.tscn")
	instance.add_child(load("res://Scenes/Building/"+scene_name+"/health_bar.tscn").instantiate())

	var script = "res://Scenes/Building/"+scene_name+"/"+scene_name+".gd"
	FileAccess.file_exists(script)
	if FileAccess.file_exists(script):
		instance.set_script(load(script))
		instance._ready()

func load_script_from_name(scene_name: String):
	var script = "res://Scenes/Building/"+scene_name+"/"+scene_name+".gd"
	FileAccess.file_exists(script)
	if FileAccess.file_exists(script):
		temp_instance.set_script(load(script))
		temp_instance._ready()
	return temp_instance.get_instance_id()

func snap(pos: Vector2) -> Vector2:
	var x = round(pos.x / 25.0) * 25
	var y = round(pos.y / 25.0) * 25
	
	x = clamp(x, -750, 750)
	if y <= 0:
		y = clamp(y, -450, -150)
	if y >= 0:
		y = clamp(y, 125, 425)
	
	return Vector2(x, y)
