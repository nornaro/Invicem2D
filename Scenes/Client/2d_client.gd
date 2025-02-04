extends Node

@onready var buildings = preload("res://Scenes/Buildings/buildings.tscn")
@onready var map = preload("res://Scenes/Map/map.tscn")
@onready var ui = preload("res://Scenes/UI/ui.tscn")
@onready var camera = preload("res://Scenes/Camera/camera.tscn")
@onready var minions = preload("res://Scenes/Minions/minions.tscn")
@onready var timer = preload("res://Scenes/Client/RoundTimer.tscn")
##2DO MP connect not ok

@export var server_ip : String = "127.0.0.1"  # IP address of the server
@export var server_port : int = 9999  # Port to connect to
@export var player_id: int

func _ready() -> void:
	get_tree().call_group("Main","add_child", timer.instantiate())
	add_child(minions.instantiate())
	add_child(map.instantiate())
	add_child(buildings.instantiate())
	add_child(ui.instantiate())
	add_child(camera.instantiate())

func _on_home_screen_property_list_changed() -> void:
	Global.style = $HomeScreen.style
