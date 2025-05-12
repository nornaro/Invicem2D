extends Node2D

var overlapping:bool = true


@export var Data: Dictionary = {}

# 2DO Placement grid?
var normal_color: Color = Color(1, 1, 1, 1) # original color
var placement_color: Color = Color(1, 1, 1, 0.5) # original color
var collision_color: Color = Color(1, 0.5, 0.5, 0.5) # redish color
var temp_instance:int
var placement:bool = false
var drag:bool = false
var rectangle:Area2D = Area2D.new()
var collides:Array
@export var showCollision:bool = false
@onready var UI: Node
@onready var scene:PackedScene = preload("res://Scenes/Buildings/Building/building.tscn")
var mapsize:Vector2 = Vector2.ZERO
var building_path:String = "res://Scenes/Buildings/Building/"

func _ready() -> void:
	Global.RL.dir_to_items(building_path, "Buildings")
	Global.RL.dir_to_items(building_path + "Turret/Type/", "Turret")
	add_buildings_list()
	Global.Items["Buildings"].erase("Castle")
	var map:Node = get_tree().get_first_node_in_group("Map")
	if map:
		mapsize = map.get_node("Ground/CollisionShape2D").shape.size
	add_json_list("Buildings")
	build_castle("Castle")

func add_buildings_list() -> void:
	for building:String in Global.Items["Buildings"]:
		var instance:Node = Node.new()
		instance.name = building
		add_child(instance)
		
func _input(event: InputEvent) -> void:
	UI = get_tree().get_first_node_in_group("UI")
	if !is_instance_valid(UI):
		return
	if event.is_action_released("ShowCollisionToggle"):
		var buildings:Array = get_tree().get_nodes_in_group("building")
		showCollision = !showCollision
		for building:Node in buildings:
			building.get_parent().get_node("Select/green").visible = showCollision
			building.get_parent().get_node("Select/red").visible = false
	if !temp_instance:
		groups(event)
		return
	var instance:Node = instance_from_id(temp_instance)
	turn_turret(instance.get_node("Sprite"))
	if event.is_action_pressed("RMB"):
		get_tree().call_group("selected", "set_selected", false)
		get_tree().call_group("Outline", "hide")
		clear_collision()
		UI.text = ""
		return
	instance.position = snap(get_global_mouse_position())
	if instance.get_node("Sprite").get_sprite_frames().has_meta("position_offset"):
		instance.position += instance.get_node("Sprite").get_sprite_frames().get_meta("position_offset")
	collides = get_tree().get_nodes_in_group(str(instance.get_node("Area").get_instance_id()))
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
	
	#Groups
func groups(event: InputEvent) -> void:
	if !event is InputEventKey:
		return
	if !event.pressed:
		return
	if ![0,1,2,3,4,5,6,7,8,9].find(event.keycode):
		return
	if Input.is_action_pressed("Ctrl"):
		get_tree().call_group("Selected","add_to_group",event.keycode)
	if Input.is_action_pressed("Shift"):
		get_tree().call_group(event.keycode,"add_to_group","Selected")

func turn_turret(sp:Node) -> void:
	if sp.get_parent().get_parent().name != "Turret":
		return
	sp.set_frame(0)
	if get_global_mouse_position().y < 0:
		sp.set_frame(32)

func show_collision(instance: Node,colliders:Array) -> void:
	if !showCollision:
		instance.get_node("Select/green").hide()
		instance.get_node("Select/red").hide()
		return
	instance.get_node("Select/green").show()
	var buildings:Array = get_tree().get_nodes_in_group("building")
	if buildings.is_empty():		
		instance.get_node("Select/red").hide()
		return
	instance.get_node("Select/red").show()
	for building:Node in buildings:
		building.get_parent().get_node("Select/red").hide()
	for building:Node in colliders:
		building.get_parent().get_node("Select/red").show()
	
func selection_rectangle() -> void:
	rectangle.add_child(CollisionShape2D.new())
	rectangle.scale += get_local_mouse_position()	

func is_point_in_mesh_bounds(mesh: MeshInstance2D, point: Vector2) -> bool:
	var mesh_extents:Vector3 = mesh.mesh.get_aabb().size / 2
	var mesh_extents_2d:Vector2 = Vector2(mesh_extents.x, mesh_extents.y) * mesh.scale
	var min_point:Vector2 = mesh.global_position - mesh_extents_2d
	var max_point:Vector2 = mesh.global_position + mesh_extents_2d

	return point.x > min_point.x and point.x < max_point.x and point.y > min_point.y and point.y < max_point.y

func instance_scene_from_name(scene_name: String,parent_scene_name: String) -> int:
	var old:StaticBody2D
	var instance: StaticBody2D
	if temp_instance:
		old = instance_from_id(temp_instance)
		old.remove_from_group("temp")
		get_tree().call_group("Outline", "hide")
	instance = scene.instantiate()
	instance.add_to_group("temp")
	get_tree().call_group("Outline", "show")
	if old:
		old.get_node("Area").add_to_group(str(instance.get_node("Area").get_instance_id()))
	instance.position = snap(get_global_mouse_position())
	#var client:Node = get_tree().get_first_node_in_group("Client")
	instance.z_index = int(instance.position.y + mapsize.y/2 - 2000)
	instance.name = scene_name
	instance.add_to_group(parent_scene_name)
	instance.modulate = placement_color
	temp_instance = instance.get_instance_id()
	get_node(parent_scene_name).add_child(instance)
	return temp_instance

func build_castle(scene_name:String) -> void:
	var instance:Node = scene.instantiate()
	instance.name = str(instance.get_instance_id())
	get_node(scene_name).add_child(instance)
	instance.modulate = normal_color
	instance.get_node("Sprite").offset.y -= 100

	var script:String = building_path + scene_name+"/"+scene_name+".gd"
	Global.RL.file_exists(script)
	if Global.RL.file_exists(script):
		instance.set_script(Global.RL.load(script))
		instance._ready()

func load_script_from_name(id:int,scene_name: String,parent_scene_name: String) -> int:
	if !temp_instance:
		return 0
	var instance:Node = instance_from_id(temp_instance)
	instance = instance_from_id(id)
	var script:String = building_path + parent_scene_name+"/"+parent_scene_name+".gd"
	Global.RL.file_exists(script)
	if Global.RL.file_exists(script):
		instance.set_script(Global.RL.load(script))
		script = building_path + parent_scene_name+"/"+scene_name+"/"+scene_name+".gd"
		if Global.RL.file_exists(script):
			var external:GDScript = Global.RL.load(script).new()
			instance.Data.merge(external.Data)
		instance._ready()
	return temp_instance

func snap(pos: Vector2) -> Vector2:
	var x:int = round(pos.x / 25.0) * 25
	var y:int = round(pos.y / 25.0) * 25
	
	x = clamp(x, -750, 750)
	if y <= 0: y = clamp(y, -450, -150)
	if y >= 0: y = clamp(y, 125, 425)
	return Vector2(x, y)

func change_buildings(text:String, change:bool) -> void:
	if !text:
		return
	var instance:Node
	if temp_instance:
		instance = instance_from_id(temp_instance)
	if is_instance_valid(instance):
		if !change:
			load_script_from_name(temp_instance, text, building_logic(text) )
			instance.modulate = normal_color
		if change:
			clear_collision()
	if is_instance_valid(instance):
		if get_tree().get_nodes_in_group(str(instance.get_node("Area").get_instance_id())):
			return
	instance_scene_from_name(text, building_logic(text))
	
func building_logic(text:String) -> String:
	if Global.Items["Buildings"].has(text):
		return text
	if Global.Items["Turret"].has(text):
		return "Turret"
	return ""
		
func clear_collision() -> void:
	var instance:Node
	if temp_instance:
		instance = instance_from_id(temp_instance)
	if is_instance_valid(instance):
		var id:int = instance.get_node("Area").get_instance_id() #2DO
		for area:Area2D in get_tree().get_nodes_in_group(str(id)):
			area.remove_from_group(str(id))
		instance.queue_free()
		instance = null		
	temp_instance = 0
	collides = []

func add_json_list(list:String) -> void:
	for item:String in Global.Items[list]:
		if !get_tree().get_first_node_in_group("Buildings"):
			continue
		if !get_tree().get_first_node_in_group("Buildings").get_node_or_null(item):
			continue
		var path:String = building_path + item + "/" + item + ".json"
		var file:JSON = Global.RL.load(path)
		var json:Dictionary = file.get_data()
		if !json.has("menu"):
			continue
		if !Global.Items.has(item):
			Global.Items[item] = []
		Global.Items[item].append(json)
