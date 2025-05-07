## Edit file: res://Scenes/Multiplayer/Network/NetFox/host.gd
extends Node

# Configuration
@export var port: int = 8890
var host_ip: String = "tomfol.io"
var game_id: String = ""
var local_port: int = 0

# Connection
var peer: ENetMultiplayerPeer
var players: Dictionary = {}

func host() -> void:
	# Connect to Noray relay
	var err: int = await Noray.connect_to_host(host_ip)
	if err != OK:
		push_error("Noray connection failed: %s" % error_string(err))
		return
	
	# Get our public Noray ID
	await Noray.pid
	print(Noray.pid)
	err = await Noray.register_remote(port)
	if err != OK:
		push_error("Noray registration failed: %s" % error_string(err))
		return
	
	local_port = Noray.local_port
	if local_port <= 0:
		push_error("Invalid local port")
		return
	
	# Start ENet server
	peer = ENetMultiplayerPeer.new()
	err = peer.create_server(port)
	if err != OK:
		push_error("Server creation failed: %s" % error_string(err))
		return
	
	multiplayer.multiplayer_peer = peer
	
	# Print connection info for clients
	print_rich("[color=green][SERVER STARTED][/color]")
	print_rich("Noray OID: %s" % Noray.local_oid)
	print_rich("Local IP: %s" % IP.get_local_addresses()[0])
	print_rich("Port: %d" % port)

func lobby() -> void:
	# Implement server browser/listings here
	pass

func _on_peer_connected(id: int) -> void:
	print("Player connected: ", id)
	players[id] = true
	get_tree().get_first_node_in_group("Server").add_player(id)

func _on_peer_disconnected(id: int) -> void:
	print("Player disconnected: ", id)
	players.erase(id)
	get_tree().get_first_node_in_group("Server").remove_player(id)

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	Noray.on_connect_nat.connect(_handle_noray_connect)
	Noray.on_connect_relay.connect(_handle_noray_connect)

func _handle_noray_connect() -> Error:
	var peer: ENetMultiplayerPeer = multiplayer.multiplayer_peer
	return await PacketHandshake.over_enet(peer.host, host_ip, port)
