extends Node

@onready var minion = preload("res://Scenes/Minions/minion.tscn")

#
#func data(data: Dictionary):
	#rpc_id(1, "process_data", data)

@rpc("any_peer")
func process_data(data: Dictionary):
	rpc_id(1, "process_data", data)

@rpc("any_peer")
func receive_response(response: Dictionary):
	print_debug("Client received response from server:", response)

@rpc("any_peer")
func spawn(data: Dictionary):
	var spawnin = get_tree().get_first_node_in_group("In")
	var minions = get_tree().get_first_node_in_group("Minions")
	var old_minion = minions.get_node(str(data.name))
	minions.remove_child(old_minion)
	old_minion.queue_free()
	if is_in_group("temp"):
		return
	var instance = minion.instantiate()
	instance.Data = data
	instance.add_to_group("minions")
	instance.get_node("Area").set_meta("owner",data.id)
	instance.position = Vector2(spawnin.position.x,data.gposy)
	instance.name = str(data.name)#str(instance.get_instance_id())
	minions.add_child(instance)
