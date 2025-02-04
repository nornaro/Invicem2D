extends Node
	
@rpc("any_peer")
func process_data(data: Dictionary):
	var index = Global.clients.find(data.id)
	if index == -1:
		return -1  # ID not found
	var id = Global.clients[(index + 1) % Global.clients.size()]  # Wrap around
	rpc_id(id, "spawn", data)

@rpc("any_peer")
func receive_response(response: Dictionary):
	print_debug("Client received response from server:", response)

@rpc("any_peer")
func spawn(data: Dictionary):
	pass
