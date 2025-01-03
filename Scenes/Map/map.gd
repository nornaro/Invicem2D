extends Node2D

var mapsize: Vector2 

func _ready():
	z_index = -1
	mapsize = $Ground/CollisionShape2D.shape.size
	var disable: Array[Vector2i] = []
	disable.append(Vector2i(1,2))
	$Top.set_disabled_points(disable)

func _on_out_area_entered(area):
	var body = area.get_parent()
	if !body.is_in_group("minions"):
		return
	body.global_position.x = $In.global_position.x
	body.get_node("Area2D").set_meta("owner",1)
	body.set_meta("owner",1)
