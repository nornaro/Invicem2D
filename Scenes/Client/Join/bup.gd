extends Node
#
#var player: PackedScene = preload("res://Scenes/Server/client.tscn")
#var server: NetworkMgr = NetworkMgr.new()
#var server_node: Node
#
#func _ready() -> void:
	#server_node = get_tree().get_first_node_in_group("Server")
#
#func join() -> void:
	#var peer = ENetMultiplayerPeer.new()
	#peer.create_client(str(server.ip),server.port)
	#multiplayer.multiplayer_peer = peer
	#multiplayer.connected_to_server.connect(connected)
	#multiplayer.server_disconnected.connect(disconnected)
	#
#
#@rpc("any_peer")
#func remove_player(id):
	#server_node.get_node_or_null(str(id)).queue_free()
#
###############
#
#func connected():
	#add_player.rpc_id(1, multiplayer.get_unique_id())
	#print_debug("Successfully connected to server!")
#
#func disconnected():
	#push_warning("Connection lost")
	#remove_player.rpc_id(multiplayer.get_unique_id())
#
#@rpc("any_peer")
#func add_player(id):
	#var player_instance = player.instantiate()
	#player_instance.name = str(id)
	#server_node.add_child(player_instance)
#
## rpc declaration must match server script, but definition can be different.
#@rpc("any_peer", "call_remote", "reliable")
#func my_relay_rpc(_data: String):
	#pass
#
#func _input(event: InputEvent) -> void:
	#if event.is_action("ui_accept"):
		#var response = "My player name is: " + str(multiplayer.get_unique_id())
		#my_relay_rpc.rpc_id(1, response)
