extends Node

@export var dummy_client: PackedScene = preload("res://Scenes/Multiplayer/dummy_client.tscn")

@rpc("any_peer")
func process_data(data: Dictionary) -> void:
	rpc_id(data.id, "spawn", data)

@rpc("any_peer")
func receive_response(response: Dictionary) -> void:
	print_debug("Client received response from server:", response)

@rpc("any_peer")
func spawn(_data: Dictionary) -> void:
	pass

@rpc("any_peer")
func set_player_name(player_name:String, player_id: int) -> void:
	Global.clients[player_id]["name"] = player_name
