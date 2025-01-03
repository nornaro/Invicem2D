extends MultiplayerSpawner

@export var max_players : int = 128
var players : Array = []  # List to store player IDs in the order of their connection
@onready var player_scene = preload("res://Scenes/Client/2d_client.tscn")  # Reference to your player scene

func _ready() -> void:
	print("Server started.")
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(9999, max_players)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(on_peer_connected)
	multiplayer.peer_disconnected.connect(on_peer_disconnected)
	print("Server ready, waiting for clients...")

func on_peer_connected(id: int) -> void:
	print("Player connected with ID: %d" % id)
	players.append(id)
	var player_instance = player_scene.instantiate()
	player_instance.name = str(players.size())
	add_child(player_instance)
	player_instance.start()

func on_peer_disconnected(id: int) -> void:
	print("Player disconnected with ID: %d" % id)
	players.erase(id)
