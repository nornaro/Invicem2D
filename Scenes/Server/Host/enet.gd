extends Node

var player: PackedScene = preload("res://Scenes/Server/client.tscn")
var server: NetworkMgr = NetworkMgr.new()
var server_node = Node

func host() -> void:
	server_node = get_tree().get_first_node_in_group("Server")
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(6666)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
@rpc("any_peer", "call_remote", "reliable")
func my_relay_rpc(data: String):
	print_debug(data)
	
@rpc("any_peer")
func add_player(id):
	if server_node.get_node_or_null(str(id)):
		return
	var player_instance = player.instantiate()
	player_instance.name = str(id)
	server_node.add_child(player_instance)
	Global.clients.append(id)
	Global.clienthp[id] = 100
	
	
	#if Global.clients.keys().is_empty():
		#Global.clients[1] = id
		#return
	#Global.clients[Global.clients.keys().max()+1] = id
	
@rpc("any_peer")
func remove_player(id):
	if server_node.get_node(str(id)):
		server_node.get_node(str(id)).queue_free()
		Global.clients.erase(id)

func _on_connected_to_server():
	print_debug("Successfully connected to server!")
