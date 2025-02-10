extends Timer

var server: Node

func _ready() -> void:
	server = get_tree().get_first_node_in_group("Server")
	connect("timeout",broadcast)
	
func broadcast() -> void:
	server.broadcast()
