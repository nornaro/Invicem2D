extends Area2D

func _on_area_entered(area:Area2D) -> void:
	if !area.get_parent().get_parent().name == "Castle":
		return
	area.get_parent().life_stolen()
	get_parent().queue_free()
