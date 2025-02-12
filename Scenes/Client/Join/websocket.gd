extends Node

const DEF_PORT = 8080
const PROTO_NAME = "ludus"

var player: PackedScene = preload("res://Scenes/Client/2d_client.tscn")
var server_node: Node
var peer = WebSocketMultiplayerPeer.new()
var uid: String
var search = true

# Start by listening to the broadcast port
func lobby() -> void:
	# No need to listen like UDP server in ENet case
	search = true
	set_process(true)  # Will poll for incoming broadcasts

# Join the server at a given IP address
func join(ip: String = "localhost") -> void:
	peer.supported_protocols = [PROTO_NAME]
	var result = peer.create_client("ws://" + ip + ":" + str(DEF_PORT))
	if result != OK:
		print("Failed to connect to server:", result)
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.connected_to_server.connect(connected)
	multiplayer.server_disconnected.connect(disconnected)

@rpc("any_peer")
func remove_player(id):
	server_node.get_node_or_null(str(id)).queue_free()

func connected():
	add_player(multiplayer.get_unique_id())

func disconnected():
	push_warning("Connection lost")
	remove_player.rpc_id(multiplayer.get_unique_id())

@rpc("any_peer")
func add_player(id):
	var player_instance = player.instantiate()
	player_instance.name = str(id)
	server_node.add_child(player_instance)
	Global.clients.append(id)
	Global.clienthp[id] = 100

@rpc("any_peer", "call_remote", "reliable")
func my_relay_rpc(data: String):
	print_debug(data)

# Handle the received packets with discovery info and process
func _process(_delta):
	if !search:
		return
	# Simulating the UDP-like discovery broadcast process (no discovery as in ENet)
	# Example of a parsed server response (you'll adjust this part to handle incoming broadcasts if needed)
	# Simulating reception of JSON-based server information
	if UDPServer.is_connection_available():
		var packet = udp_peer.get_packet() # Replace with proper broadcast logic
		# Here, you handle it similar to what your ENet solution does
		var packet_data = JSON.parse_string(packet.get_string_from_utf8())
		Global.servers[packet_data.UID] = packet_data
		Global.servers[packet_data.UID]["Join"] = packet_data.IP + ":" + str(packet_data.Port)
