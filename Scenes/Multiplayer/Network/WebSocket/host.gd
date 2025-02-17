extends Node

var port: int
var player:PackedScene

func host() -> void:
	player = Global.dummy_client
	var peer:WebSocketMultiplayerPeer = WebSocketMultiplayerPeer.new()
	multiplayer.multiplayer_peer = null
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	set_process(true)
	await get_tree().create_timer(3.0).timeout
	print_debug("Status after 3s:", multiplayer.multiplayer_peer.get_connection_status())

#func _process(delta: float) -> void:
	#print_debug("Status after 3s:", multiplayer.multiplayer_peer.get_connection_status())
