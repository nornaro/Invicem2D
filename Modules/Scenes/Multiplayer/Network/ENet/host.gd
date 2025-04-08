extends Node

var player: PackedScene
var port: int
var server_node: Node

var udp_peer := PacketPeerUDP.new()
var broadcast_port: int = 4242
var broadcast_address: String = "255.255.255.255"
var uid: String

#func host():
	#server_node = get_tree().get_current_scene().get_node("Server")
	#server_node.player = Global.dummy_client
	#var server_peer = ENetMultiplayerPeer.new()
	#server_peer.create_server(8080)
	#multiplayer.multiplayer_peer = server_peer
	#multiplayer.peer_connected.connect(_add_player_to_game)
	#multiplayer.peer_disconnected.connect(_del_player)
#
#func _add_player_to_game(id: int):
	#server_node.add_player(id)
	#
#func _del_player(id: int):
	#server_node.remove_player(id)


func host():
	server_node = get_tree().get_current_scene().get_node("Server")
	server_node.player = Global.dummy_client
	uid = Marshalls.utf8_to_base64(str(Time.get_ticks_msec()) + str(randf()))
	uid = CryptoKey.generate_scene_unique_id()
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port)
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
	
func _disconnnected(id: int) -> void:
	server_node.remove_player(id)

func _connnected(id: int) -> void:
	server_node.add_player(id)

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
		"Latency": 0,
	}
	
	udp_peer.put_packet(JSON.stringify(lobby).to_utf8_buffer())
