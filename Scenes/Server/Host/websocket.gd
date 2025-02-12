extends Node

const DEF_PORT = 8080
const PROTO_NAME = "ludus"

var player: PackedScene = preload("res://Scenes/Server/client.tscn")
var server_node: Node
var peer = WebSocketMultiplayerPeer.new()
var uid: String

# Hosting function
func host() -> void:
	server_node = get_tree().get_first_node_in_group("Server")
	uid = CryptoKey.generate_scene_unique_id()  # Keep unique ID generation
	peer.supported_protocols = [PROTO_NAME]
	
	var result = peer.create_server(DEF_PORT)  # Create WebSocket server
	if result != OK:
		print("Failed to start WebSocket server on port %d" % DEF_PORT)
		return

	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	print("Server started on port", DEF_PORT)

# Relay RPC for debugging/logging
@rpc("any_peer", "call_remote", "reliable")
func my_relay_rpc(data: String):
	print_debug(data)

# Add a player to the server
@rpc("any_peer")
func add_player(id):
	if server_node.get_node_or_null(str(id)):
		return
	var player_instance = player.instantiate()  # Create the player instance
	player_instance.name = str(id)  # Assign player a unique name (ID)
	server_node.add_child(player_instance)  # Add player instance to the server
	Global.clients.append(id)  # Keep track of connected clients
	Global.clienthp[id] = 100  # Initialize client HP

# Remove a player from the server
@rpc("any_peer")
func remove_player(id):
	if server_node.get_node(str(id)):
		server_node.get_node(str(id)).queue_free()  # Remove player node from server
		Global.clients.erase(id)  # Erase from the client list

# Handle successful connection
func _connected():
	print_debug("Successfully connected to server!")

# Close the WebSocket server properly
func _close_network():
	multiplayer.multiplayer_peer = null
	peer.close()

# Handle peer connection and disconnection for logging
func _peer_connected(id):
	print("Peer connected: %d" % id)

func _peer_disconnected(id):
	print("Disconnected %d" % id)
