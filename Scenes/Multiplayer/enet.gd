extends Node

#var player: PackedScene = preload("res://Scenes/Server/client.tscn")
#var server: NetworkMgr = NetworkMgr.new()
#
#
#func host() -> void:
	#var peer = ENetMultiplayerPeer.new()
	#peer.create_server(server.port)
	#multiplayer.multiplayer_peer = peer
	#
#@rpc("any_peer", "call_remote", "reliable")
#func my_relay_rpc(data: String):
	#print_debug(data)
	##my_relay_rpc.rpc_id(multiplayer.get_remote_sender_id(), "Hello %s this is server replying " % [data])
	#
#@rpc("any_peer")
#func add_player(id):
	#var player_instance = player.instantiate()
	#player_instance.name = str(id)
	#%Players.add_child(player_instance)
#
#@rpc("any_peer")
#func remove_player(id):
	#if %Players.get_node(str(id)):
		#%Players.get_node(str(id)).queue_free()
#
#func _on_connected_to_server():
	#print_debug_debug("Successfully connected to server!")
