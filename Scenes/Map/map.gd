extends Node2D

var mapsize: Vector2 
var network: Node

func _ready():
	network = get_tree().get_first_node_in_group("Network")
	z_index = -4096
	mapsize = $Ground/CollisionShape2D.shape.size
	var disable: Array[Vector2i] = []
	disable.append(Vector2i(1,2))
	$Top.set_disabled_points(disable)

func _on_out_area_entered(area):
	var body = area.get_parent()
	if !body.is_in_group("minions"):
		return
	body.Data["id"] = multiplayer.get_unique_id()
	body.Data["gposy"] = body.global_position.y
	#get_tree().call_group("Network","data",body.Data)
	if Global.mp:
		network.process_data(body.Data)
		return
	#send request to server, server reads body.Data
	body.global_position.x = $In.global_position.x
	body.get_node("Area").set_meta("owner",1)
	body.set_meta("owner",1)
