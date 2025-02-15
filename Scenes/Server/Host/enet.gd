extends Node

var player: PackedScene = preload("res://Scenes/Server/client.tscn")
var port: int = 6666
var server_node: Node

var udp_peer := PacketPeerUDP.new()
var broadcast_port: int = 4242
var broadcast_address: String = "255.255.255.255"
var uid: String

func host() -> void:
	server_node = get_tree().get_first_node_in_group("Server")
	uid = Marshalls.utf8_to_base64(str(Time.get_ticks_msec()) + str(randf()))
	uid = CryptoKey.generate_scene_unique_id()
	var peer:ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	peer.create_server(port)
	peer.set_bind_ip("192.168.1.2")
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_connnected)
	multiplayer.peer_disconnected.connect(_disconnnected)
	set_process(true)

func is_port_free() -> bool:
	var temp_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var result: int = temp_peer.create_server(port)
	if result:
		temp_peer.close()
		port += 1
		return false
	return true
	
@rpc("any_peer", "call_remote", "reliable")
func my_relay_rpc(data: String) -> void:
	print_debug(data)

	
func _disconnnected(id: int) -> void:
	remove_player(id)

func _connnected(id: int) -> void:
	add_player(id)
	
@rpc("any_peer")
func add_player(id: int) -> void:
	if server_node.get_node_or_null(str(id)):
		return
	var player_instance: Node = player.instantiate()
	player_instance.name = str(id)
	server_node.add_child(player_instance)
	Global.clients[id] = {}
	Global.clients[id]["hp"] = 100
	Global.clients[id]["score"] = 0
	Global.clients[id]["name"] = ""

@rpc("any_peer")
func remove_player(id: int) -> void:
	if server_node.get_node(str(id)):
		server_node.get_node(str(id)).queue_free()
		Global.clients.erase(id)

func _on_connected_to_server() -> void:
	print_debug("Successfully connected to server!")

# Handle incoming discovery requests
func _process(_delta: float) -> void:
	udp_peer.connect_to_host(broadcast_address, broadcast_port)
	var lobby: Dictionary = {
		"UID": uid,
		"Port":port,
		"Name": "ENetTest",
		"Game": Global.game,
		"Players": Global.clients,
		"Id": multiplayer.get_unique_id(),
		"Latency": Time.get_ticks_msec(),
	}
	
	udp_peer.put_packet(JSON.stringify(lobby).to_utf8_buffer())
