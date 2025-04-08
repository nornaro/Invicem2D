extends Node

var player: PackedScene

@rpc("any_peer")
func process_data(data: Dictionary) -> void:
	rpc_id(data.id, "spawn", data)

@rpc("any_peer")
func receive_response(response: Dictionary) -> void:
	print_debug("Client received response from server:", response)

@rpc("any_peer")
func set_player_name(player_name:String, player_id: int) -> void:
	Global.clients[player_id]["name"] = player_name

@rpc("any_peer", "call_remote", "reliable")
func my_relay_rpc(data: String) -> void:
	print_debug(data)
	
@rpc("any_peer")
func add_player(id: int) -> void:
	if get_node_or_null(str(id)):
		return
	var player_instance: Node = player.instantiate()
	player_instance.name = str(id)
	add_child(player_instance)
	Global.id = id
	Global.clients[id] = {}
	Global.clients[id]["hp"] = 100
	Global.clients[id]["score"] = 0
	Global.clients[id]["name"] = ""

@rpc("any_peer")
func remove_player(id: int) -> void:
	if get_node(str(id)):
		get_node(str(id)).queue_free()
		Global.clients.erase(id)

@rpc("authority", "call_remote", "reliable")
func spawn(_clients: Dictionary) -> void:
	#var lb: Node = get_tree().get_first_node_in_group("Leaderboard")
	#if lb:
		#lb.update(clients)
	get_tree().call_group("Barrack", "spawn", {})
