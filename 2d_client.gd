extends Node

func _ready():
	pass
	
"""

$Building, 
$Camera, 
$Controls, 
$Hud,
$Map, 
$Minions, 
$Placement, 
$Timer
$UI, 

"""

func _on_minion_timeout():
	if !$Buildings.get_node_or_null("Barrack"):
		return
	if !get_node_or_null("Minions"):
		return
	if !get_node_or_null("Map"):
		return
	if get_tree().get_nodes_in_group("minions").size()>=500:
		return
	$Buildings.get_node("Barrack").spawn(get_node("Minions"),get_node("Map").get_node("Spawn"))
