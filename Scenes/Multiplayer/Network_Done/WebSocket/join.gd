extends Node

var port: int = 9001
var server_node: Node
var peer:WebSocketMultiplayerPeer = WebSocketMultiplayerPeer.new()

func _init() -> void:
	peer.supported_protocols = ["ludus"]

func _ready() -> void:
	multiplayer.peer_connected.connect(_peer_connected)
	multiplayer.server_disconnected.connect(_disconnected)
	multiplayer.connection_failed.connect(_disconnected)
	multiplayer.connected_to_server.connect(_connected)

func lobby() -> void:
	pass
	
func join() -> void:
	server_node = get_tree().get_first_node_in_group("Server")
	server_node.player = Global.client
	multiplayer.multiplayer_peer = null
	peer.create_client("ws://127.0.0.1:"+str(9001))
	multiplayer.multiplayer_peer = peer

func _connected() -> void:
	print_debug("Successfully connected to server!")
	server_node.add_player(multiplayer.get_unique_id())

func _disconnected() -> void:
	multiplayer.multiplayer_peer = null
	peer.close()

func _peer_connected(id: int) -> void:
	print_debug(str(id)+" Successfully connected to server!")
