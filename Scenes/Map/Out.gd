extends Area2D

func _on_area_entered(area):
	if area.get_parent().is_in_group("minions"):
		area.get_parent().position.x = $"../In".position.x
