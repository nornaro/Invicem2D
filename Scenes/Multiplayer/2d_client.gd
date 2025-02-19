extends Node

@onready var buildings: PackedScene = preload("res://Scenes/Build/build.tscn")
@onready var map: PackedScene = preload("res://Scenes/Map/map.tscn")
@onready var ui: PackedScene = preload("res://Scenes/UI/ui.tscn")
@onready var camera: PackedScene = preload("res://Scenes/Camera/camera.tscn")
@onready var minions: PackedScene = preload("res://Scenes/Minions/minions.tscn")
@onready var round_timer: PackedScene = preload("res://Scenes/Multiplayer/dummy_timer.tscn")
@onready var aspd_timer: PackedScene = preload("res://Scenes/Multiplayer/aspd_timer.tscn")
#@onready var black: PackedScene = preload("res://Scenes/Multiplayer/black.tscn")

##2DO MP connect not ok

@export var server_ip : String = "127.0.0.1"  # IP address of the server
@export var server_port : int = 9999  # Port to connect to
@export var player_id: int

func _ready() -> void:
	get_tree().call_group("Main","add_child", round_timer.instantiate())
	var instance:Node = minions.instantiate()
	instance.connect("done",_load_next)
	add_child(instance)
	
func _load_next() -> void:
	#for thread:Thread in Global.threads:
		#thread.start()
	add_child(aspd_timer.instantiate())
	add_child(map.instantiate())
	add_child(buildings.instantiate())
	add_child(ui.instantiate())
	#add_child(black.instantiate())	
	add_child(camera.instantiate())

func _on_home_screen_property_list_changed() -> void:
	Global.style = $HomeScreen.style
