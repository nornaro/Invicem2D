extends Node

@onready var buildings = preload("res://Scenes/Buildings/buildings.tscn")
@onready var map = preload("res://Scenes/Map/map.tscn")
@onready var ui = preload("res://Scenes/UI/ui.tscn")
@onready var camera = preload("res://Scenes/Camera/camera.tscn")
@onready var minions = preload("res://Scenes/Minions/minions.tscn")
@onready var client = preload("res://Scenes/Client/2d_client.tscn")

@export var server_ip : String = "127.0.0.1"  # IP address of the server
@export var server_port : int = 9999  # Port to connect to

var peer : ENetMultiplayerPeer

func _ready() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(server_ip, server_port)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(on_connected)
	multiplayer.peer_disconnected.connect(on_disconnected)

	push_warning("Connecting to server...")

func on_connected() -> void:
	push_warning("Connected to server.")
	# Call start when connected to server to initialize scenes
	start()

func on_disconnected() -> void:
	push_warning("Disconnected from server.")

func start():
	add_child(minions.instantiate())
	add_child(map.instantiate())
	add_child(buildings.instantiate())
	add_child(ui.instantiate())
	add_child(camera.instantiate())

func _on_home_screen_property_list_changed() -> void:
	Global.style = $HomeScreen.style

# Correctly using @rpc annotation for remote function
@rpc
func _spawn_player(position: Vector2) -> void:
	var player_instance = client.instantiate()  # Assuming a player scene exists
	add_child(player_instance)
	player_instance.global_position = position
	push_warning("Player spawned at: %s" % position)
