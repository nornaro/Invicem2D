extends Node

@export var player_id: int
@onready var minion:PackedScene = preload("res://Scenes/Minions/minion.tscn")

#
#func data(data: Dictionary):
	#rpc_id(1, "process_data", data)

@rpc("any_peer")
func process_data(data: Dictionary) -> void:
	rpc_id(1, "process_data", data)

@rpc("any_peer")
func receive_response(response: Dictionary) -> void:
	print_debug("Client received response from server:", response)

@rpc("any_peer")
func set_player_name(player_name:String, id: int) -> void:
	rpc_id(1, "set_player_name", player_name,id)

@rpc("any_peer")
func spawn(data: Dictionary) -> void:
	var spawnin: Area2D = get_tree().get_first_node_in_group("In")
	var rect: Rect2 = spawnin.shape.get_rect()
	var x: float = randf_range(rect.position.x, rect.position.x + rect.size.x) + 50
	var y: float = randf_range(rect.position.y, rect.position.y + rect.size.y)
	data.global_position = spawnin.global_position + Vector2(x, y)
	get_tree().call_group("Barrack","spawn",data)
