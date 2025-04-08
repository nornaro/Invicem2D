extends Node

var port: int = 9001
var server_node: Node
var uid: String
var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

func lobby() -> void:
	pass

func join() -> void:
	server_node = get_tree().get_first_node_in_group("Server")
	server_node.player = Global.client
	multiplayer.connected_to_server.connect(_connected)
	multiplayer.server_disconnected.connect(_disconnected)
	var join_data: Array = Global.join_data.split(":")
	if IP.get_local_addresses().has(join_data[0]):
		join_data[0] = "127.0.0.1"
	#peer.create_client(join_data[0],int(join_data[1]))
	peer.create_client("127.0.0.1",9001)
	multiplayer.multiplayer_peer = peer
	set_process(true)

func _connected() -> void:
	print_debug("Successfully connected to server!")
	server_node.add_player(multiplayer.get_unique_id())

func _disconnected() -> void:
	push_warning("Connection lost")
	server_node.remove_player(multiplayer.get_unique_id())

func _input(event: InputEvent) -> void:
	if event.is_action("ui_accept"):
		server_node.my_relay_rpc.rpc_id(1, "My player name is: " + str(multiplayer.get_unique_id()))
