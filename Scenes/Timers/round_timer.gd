extends Timer

var server_node: Node

func _ready() -> void:
	server_node = get_tree().get_first_node_in_group("Server")
	start()

func _on_timeout() -> void:
	if Global.mp:
		server_node.spawn.rpc({})
		return
	get_tree().call_group("Barrack","spawn",{})
