extends MultiplayerSpawner

@export var max_players : int = 128
var players : Array = []  # List to store player IDs in the order of their connection
@onready var player_scene = preload("res://Scenes/Client/2d_client.tscn")  # Reference to your player scene

func _ready() -> void:
	push_warning("Server started.")
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(9999, max_players)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(on_peer_connected)
	multiplayer.peer_disconnected.connect(on_peer_disconnected)
	push_warning("Server ready, waiting for clients...")

func on_peer_connected(id: int) -> void:
	push_warning("Player connected with ID: %d" % id)
	players.append(id)
	
	# Spawn the player for the client
	var player_instance = player_scene.instantiate()
	# Do not call set_owner here. The player is automatically owned by the peer when it connects.
	player_instance.name = str(players.size())
	add_child(player_instance)
	player_instance.start()
	
	# Optionally send data to the client (e.g., player spawn location)
	# For example, to spawn at a random location:
	#player_instance.position = Vector2(randf_range(0, 1024), randf_range(0, 768))

	# Inform the client of their spawn
	#rpc_id(id, "_spawn_player", player_instance.position)

func on_peer_disconnected(id: int) -> void:
	push_warning("Player disconnected with ID: %d" % id)
	players.erase(id)

func _spawn_player(position: Vector2) -> void:
	# Called from the server to set player spawn position
	self.position = position
