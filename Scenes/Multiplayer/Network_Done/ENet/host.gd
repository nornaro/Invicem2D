extends Node

var player: PackedScene
var port: int = 9001
var server_node: Node
var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

func host():
	server_node = get_tree().get_current_scene().get_node("Server")
	server_node.player = Global.dummy_client
	peer.create_server(9001)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_connnected)
	multiplayer.peer_disconnected.connect(_disconnnected)
	set_process(true)
	
func _disconnnected(id: int) -> void:
	server_node.remove_player(id)

func _connnected(id: int) -> void:
	print_debug("Successfully connected to server!")
	server_node.add_player(id)
