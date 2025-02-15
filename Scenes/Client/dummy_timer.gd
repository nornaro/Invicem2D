extends Node

func _ready() -> void:
	pass

func _on_timeout() -> void:
	pass

@rpc("authority", "call_remote", "reliable")
func spawn(clients: Dictionary) -> void:
	var lb: Node = get_tree().get_first_node_in_group("Leaderboard")
	if lb:
		lb.update(clients)
	get_tree().call_group("Barrack", "spawn")
