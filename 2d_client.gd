extends Node

func _on_minion_timeout():
	var spawn = get_node_or_null("Map/Spawn")
	if !spawn:
		return
	if get_tree().get_nodes_in_group("minions").size()>=500:
		return
	get_tree().call_group("Barrack","spawn",%Minions,spawn)
