extends Node2D

var overlapping
@export var Data = {}

# 2DO Placement grid?
var normal_color: Color = Color(1, 1, 1, 1) # original color
var placement_color: Color = Color(1, 1, 1, 0.5) # original color
var collision_color: Color = Color(1, 0.5, 0.5, 0.5) # redish color
var temp_instance
var placement = false
var drag = false
var rectangle = Area2D.new()
var collides
@export var showCollision = false
@onready var UI: Node
@onready var scene = preload("res://Scenes/Building/building.tscn")
	
func add_buildings_list(Items):	
	for building in Items:
		var instance = Node.new()
		instance.name = building
		add_child(instance)
		
func _input(event):
	UI = $"../UI"
	if !is_instance_valid($"../UI"):
		return
	if event.is_action_released("ShowCollisionToggle"):
		var buildings = get_tree().get_nodes_in_group("building")
		showCollision = !showCollision
		for building in buildings:
			building.get_parent().get_node("Select/green").visible = showCollision
			building.get_parent().get_node("Select/red").visible = false
	if !temp_instance:
		return
	var instance = instance_from_id(temp_instance)
	turn_turret(instance.get_node("Sprite"))
	if event.is_action_pressed("RMB"):
		clear_collision()
		UI.text = ""
		return
	instance.position = snap(get_global_mouse_position())
	if instance.get_node("Sprite").get_sprite_frames().has_meta("position_offset"):
		instance.position += instance.get_node("Sprite").get_sprite_frames().get_meta("position_offset")
	collides = get_tree().get_nodes_in_group(str(instance.get_node("Area2D").get_instance_id()))
	show_collision(instance,collides)
	if collides:
		instance.modulate = collision_color
		return
	instance.modulate = placement_color
	if !UI.text:
		return
	if !UI.build:
		return
	change_buildings(UI.text, false)

func turn_turret(sp):
	if sp.get_parent().get_parent().name != "Turret":
		return
	sp.set_frame(0)
	if get_global_mouse_position().y < 0:
		sp.set_frame(32)

func show_collision(instance,collides):
	if !showCollision:
		instance.get_node("Select/green").hide()
		instance.get_node("Select/red").hide()
		return
	instance.get_node("Select/green").show()
	var buildings = get_tree().get_nodes_in_group("building")
	if buildings.is_empty():		
		instance.get_node("Select/red").hide()
		return
	instance.get_node("Select/red").show()
	for building in buildings:
		building.get_parent().get_node("Select/red").hide()
	for building in collides:
		building.get_parent().get_node("Select/red").show()
	
func selection_rectangle():
	rectangle.add_child(CollisionShape2D.new())
	rectangle.scale += get_local_mouse_position()	

func is_point_in_mesh_bounds(mesh: MeshInstance2D, point: Vector2) -> bool:
	var mesh_extents = mesh.mesh.get_aabb().size / 2
	var mesh_extents_2d = Vector2(mesh_extents.x, mesh_extents.y) * mesh.scale
	var min_point = mesh.global_position - mesh_extents_2d
	var max_point = mesh.global_position + mesh_extents_2d

	return point.x > min_point.x and point.x < max_point.x and point.y > min_point.y and point.y < max_point.y

func instance_scene_from_name(scene_name: String,parent_scene_name: String):
	var old
	var instance: StaticBody2D
	if temp_instance:
		old = instance_from_id(temp_instance)
		old.remove_from_group("temp")
	instance = scene.instantiate()
	instance.add_to_group("temp")
	if old:
		old.get_node("Area2D").add_to_group(str(instance.get_node("Area2D").get_instance_id()))
	instance.position = snap(get_global_mouse_position())
	instance.z_index = int(instance.position.y)+get_tree().root.get_node("Main/Client/Map").mapsize.y/2
	instance.name = scene_name
	instance.add_to_group(parent_scene_name)
	instance.modulate = placement_color
	temp_instance = instance.get_instance_id()
	get_node(parent_scene_name).add_child(instance)
	return temp_instance

func build_castle(scene_name):
	var instance = scene.instantiate()
	instance.name = str(instance.get_instance_id())
	get_node(scene_name).add_child(instance)
	instance.modulate = normal_color
	instance.get_node("Sprite").offset.y -= 100

	var script = "res://Scenes/Building/" + scene_name+"/"+scene_name+".gd"
	FileAccess.file_exists(script)
	if FileAccess.file_exists(script):
		instance.set_script(load(script))
		instance._ready()

func load_script_from_name(id,scene_name: String,parent_scene_name: String):
	if !temp_instance:
		return
	var instance = instance_from_id(temp_instance)
	instance = instance_from_id(id)
	var script = "res://Scenes/Building/" + parent_scene_name+"/"+parent_scene_name+".gd"
	FileAccess.file_exists(script)
	if FileAccess.file_exists(script):
		instance.set_script(load(script))
		script = "res://Scenes/Building/" + parent_scene_name+"/"+scene_name+"/"+scene_name+".gd"
		if FileAccess.file_exists(script):
			var external = load(script).new()
			instance.Data.merge(external.Data)
		instance._ready()
	return temp_instance

func snap(pos: Vector2) -> Vector2:
	var x = round(pos.x / 25.0) * 25
	var y = round(pos.y / 25.0) * 25
	
	x = clamp(x, -750, 750)
	if y <= 0: y = clamp(y, -450, -150)
	if y >= 0: y = clamp(y, 125, 425)
	return Vector2(x, y)

func change_buildings(text, change):
	if !text:
		return
	var instance
	if temp_instance:
		instance = instance_from_id(temp_instance)
	if is_instance_valid(instance):
		if !change:
			load_script_from_name(temp_instance, text, building_logic(text) )
			instance.modulate = normal_color
		if change:
			clear_collision()
	if is_instance_valid(instance):
		if get_tree().get_nodes_in_group(str(instance.get_node("Area2D").get_instance_id())):
			return
	instance_scene_from_name(text, building_logic(text))
	
func building_logic(text):
	if UI.Items["Buildings"].has(text):
		return text
	if UI.Items["Turret"].has(text):
		return "Turret"
		
func clear_collision():
	var instance
	if temp_instance:
		instance = instance_from_id(temp_instance)
	if is_instance_valid(instance):
		var id = instance.get_node("Area2D").get_instance_id() #2DO
		for area in get_tree().get_nodes_in_group(str(id)):
			area.remove_from_group(str(id))
		instance.queue_free()
		instance = null		
	temp_instance = null
	collides = []
