extends Area2D

var placement_color: Color = Color(1, 1, 1, 0.5)
var collision_color: Color = Color(1, 0.5, 0.5, 0.5)
@onready var mesh = $".."
@onready var UI = $"../../../../UI/"
@onready var Building = $"../../../../Building/"
@onready var outline = preload("res://outline.tscn")
var multiselect = false

func _ready():
	mesh.modulate = placement_color
	#instance_from_id(area)
	
func _on_area_entered(area):
	if !area.is_in_group("building"): return
	mesh.overlapping.append(area.get_instance_id())

func _on_area_exited(area):
	if !area.is_in_group("building"): return
	var id_to_remove = area.get_instance_id()
	if mesh.overlapping.has(id_to_remove):
		print(mesh.overlapping)
		var index = mesh.overlapping.find(id_to_remove)
		if index != -1:
			mesh.overlapping.erase(index)

	
func _process(_delta):
	if mesh.temp: mesh.modulate = placement_color
	$"../Select".color = "green"
	if mesh.overlapping:	
		if mesh.temp: mesh.modulate = collision_color
		$"../Select".color = "red"

	if Input.is_key_pressed(KEY_DELETE):	
		UI.get_node("Destroy").show()		
	if UI.get_node("Destroy").confirm != null:
		instance_from_id(UI.get_node("Destroy").confirm).queue_free()
		UI.get_node("Destroy").confirm = null

func _on_input_event(viewport, event, shape_idx):
	if Building.instance:
		return
	if event.is_action_pressed("LMB"):
		if multiselect: 
			Building.selected_building.append(get_parent().get_instance_id())
			add_outline()
		if !multiselect: 
			clear_selection()
			add_outline()
			Building.selected_building.append(get_parent().get_instance_id())
			show_building_menu()

func clear_selection():
	if !Building.selected_building:
		return
	#for building in Building.selected_building:
		#instance_from_id(building).outline.queue_free()
	Building.selected_building.clear()

func add_outline():
	var instance = outline.instantiate()
	#instance.global_position = global_position
	get_parent().add_child(instance)

func show_building_menu():
		UI.clear()
		if UI.fixed: 
			UI.get_node("BuildingMenuList").position = Building.BuildArea.get_local_mouse_position()
		UI.get_node("BuildingMenuList").show()

func _on_mouse_entered():
	Building.property_list = true
func _on_mouse_exited():
	Building.property_list = false
func _input(event):
	if event.is_action_pressed("Ctrl"):
		multiselect = true
	if event.is_action_released("Ctrl"):
		show_building_menu()
		multiselect = false
