extends Node

# Configuration
@export var port: int = 8890
var host: String = "tomfol.io"
var connection_timeout: Timer

# Connection
var peer: ENetMultiplayerPeer
var server_node: Node
var server_oid: String = "" # Set this to host's Noray OID


func lobby() -> void:
	# Implement server discovery here
	# Should populate server_oid with the host's Noray OID
	print("Searching for servers...")


func join() -> void:
	if server_oid.is_empty():
		push_error("No server OID specified")
		return

	server_node = get_tree().get_first_node_in_group("Server")
	if !server_node:
		push_error("Server node not found")
		return

	# Connect to Noray
	var err: int = await Noray.connect_to_host(host)
	if err != OK:
		push_error("Noray connection failed")
		return

	# Register client
	err = await Noray.register_remote()
	if err != OK:
		push_error("Noray registration failed")
		return

	# Attempt NAT connection using host's OID
	Noray.connect_nat(server_oid)

	# Wait for connection (with timeout)
	#var timeout: SceneTreeTimer = get_tree().create_timer(connection_timeout)
	var connected: bool = await Noray.on_connect_nat

	if !connected:
		push_warning("NAT failed, trying relay")
		Noray.connect_relay(server_oid)
		connected = await Noray.on_connect_relay

	if !connected:
		push_error("Failed to connect to server")
		return

	# Create ENet client
	peer = ENetMultiplayerPeer.new()
	err = peer.create_client(host, port, 0, 0, 0, Noray.local_port)
	if err != OK:
		push_error("Client creation failed")
		return

	multiplayer.multiplayer_peer = peer
	multiplayer.connected_to_server.connect(_on_connected)
	multiplayer.server_disconnected.connect(_on_disconnected)


func _on_connected() -> void:
	print("Connected to server!")
	server_node.add_player(multiplayer.get_unique_id())


func _on_disconnected() -> void:
	print("Disconnected from server")
	server_node.remove_player(multiplayer.get_unique_id())
	if peer:
		peer.close()
