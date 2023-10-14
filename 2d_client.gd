extends Node

func _on_minion_timeout():
	var spawn = get_node_or_null("Map/Spawn/CollisionShape2D")
	if !spawn:
		return
	print(get_tree().get_nodes_in_group("minions").size())
	if get_tree().get_nodes_in_group("minions").size()>=2000:
		return
	get_tree().call_group("Barrack","spawn",%Minions,spawn)
