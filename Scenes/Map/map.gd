extends Node2D

func _on_out_area_entered(area):
	if !area.get_parent().is_in_group("minions"):
		return
	area.get_parent().global_position.x = $In.global_position.x
