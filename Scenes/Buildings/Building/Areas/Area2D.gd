extends Area2D

var placement_color: Color = Color(1, 1, 1, 0.5)
var collision_color: Color = Color(1, 0.5, 0.5, 0.5)
@onready var mesh = $".."
@onready var UI = $"../../../../UI/"
@onready var Buildings = $"../../../../Buildings"
@onready var Placement = $"../../../../Placement"
@onready var Map = $"../../../../Map"
@onready var outline = preload("res://Scenes/Buildings/Building/outline.tscn")
var pointover = true
var multiselect
#var test = {"a":{}}

func _ready():
	mesh.modulate = placement_color
	
func _on_input_event(_viewport, event, _shape_idx):
	if event.is_action_released("RMB"):
		UI.List.menu(get_parent().get_parent().name)
	if event.is_action_pressed("LMB"):
		add_selection()
		
func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		clear_selection()
	if Input.is_key_pressed(KEY_DELETE):
		UI.get_node("Destroy").show()
		get_parent().get_node("outline").hide()	
	if event.is_action_pressed("Ctrl"):
		multiselect = true
	if event.is_action_released("Ctrl"):
		multiselect = false
	if pointover:
		return
	if multiselect:
		return
#	if event.is_action_pressed("RMB"):
#		clear_selection()
#	if event.is_action_pressed("LMB"):
#		clear_selection()

func _on_area_entered(area):
	if !area.is_in_group("BuildingArea"): return
	if Placement: Placement.overlapping[get_parent().get_instance_id()] = {area.get_parent().get_instance_id():null}

func _on_area_exited(area):
	if !area.is_in_group("BuildingArea"): return
	if Placement: Placement.overlapping[get_parent().get_instance_id()].erase(area.get_parent().get_instance_id())

func clear_selection():
	for building in get_tree().get_nodes_in_group("BuildingMesh"):
		if !get_parent().Data.has("selected"):
			return
		get_parent().get_node("outline").hide()
		get_parent().Data["selected"] = false
		
func add_selection():
	if !multiselect:
		clear_selection()
	get_parent().get_node("outline").show()
	get_parent().Data["selected"] = true

func _on_mouse_entered():
	pointover = true

func _on_mouse_exited():
	pointover = false
