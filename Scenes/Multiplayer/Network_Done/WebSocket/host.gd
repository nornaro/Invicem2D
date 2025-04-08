extends Node

var port: int = 9001
var server_node: Node
var peer:WebSocketMultiplayerPeer = WebSocketMultiplayerPeer.new()

func _init() -> void:
	peer.supported_protocols = ["ludus"]

func _ready() -> void:
	multiplayer.peer_connected.connect(_peer_connected)
	multiplayer.peer_disconnected.connect(_peer_disconnected)

func lobby() -> void:
	pass

func host() -> void:
	server_node = get_tree().get_first_node_in_group("Server")
	server_node.player = Global.dummy_client
	multiplayer.multiplayer_peer = null
	peer.create_server(9001)
	multiplayer.multiplayer_peer = peer

func _peer_connected(id: int) -> void:
	print_debug("Successfully connected to server!")
	server_node.add_player(id)

func _peer_disconnected(id: int) -> void:
	print_debug(str(id)+" Disconnected from server!")
	multiplayer.multiplayer_peer = null
	peer.close()






































#var player: PackedScene
#var port: int
#var server_node: Node
#var uid: String
#var peer: WebSocketMultiplayerPeer = WebSocketMultiplayerPeer.new()
#
#
#func _ready() -> void:
	#peer.supported_protocols = ["ludus"]
	#server_node = get_tree().get_first_node_in_group("Server")
	#server_node.player = Global.client
	#multiplayer.peer_connected.connect(_connected)
	#multiplayer.peer_disconnected.connect(_disconnected)
	#multiplayer.server_disconnected.connect(_close_network)
	#multiplayer.connection_failed.connect(_close_network)
	#multiplayer.connected_to_server.connect(_connected)
#
#func host() -> void:
	#multiplayer.multiplayer_peer = null
	#peer.create_server(8888)
	#multiplayer.multiplayer_peer = peer
#
#func _close_network() -> void:
	#multiplayer.multiplayer_peer = null
	#peer.close()
#
#func _connected(id: int) -> void:
	#print("_connected")
	#server_node.add_player(id)
#
#func _disconnected(id: int) -> void:
	#push_warning("Connection lost")
	#server_node.remove_player(id)
#
#func _exit_tree() -> void:
	#peer.close()
