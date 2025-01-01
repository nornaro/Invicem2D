extends Node

@onready var buildings = preload("res://Scenes/Buildings/buildings.tscn")
@onready var map = preload("res://Scenes/Map/map.tscn")
@onready var ui = preload("res://Scenes/UI/ui.tscn")
@onready var camera = preload("res://Scenes/Camera/camera.tscn")
@onready var home = preload("res://Scenes/Home/home_screen.tscn")
@export var style: String = "Fantasy"

func _ready() -> void:
	add_child(home.instantiate())

func _on_minion_timeout():
	var spawn = get_node_or_null("Map/Spawn/CollisionShape2D")
	if !spawn:
		return
	#print(get_tree().get_nodes_in_group("minions").size())
	if get_tree().get_nodes_in_group("minions").size()>=2000:
		return
	get_tree().call_group("Barrack","spawn",%Minions,spawn)

func start():
	add_child(map.instantiate())
	add_child(buildings.instantiate())
	add_child(ui.instantiate())
	add_child(camera.instantiate())


func _on_home_screen_property_list_changed() -> void:
	style = $"HomeScreen".style
