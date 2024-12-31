extends Area2D

func _on_area_exited(area: Area2D) -> void:
	if area.has_meta("projectile"):
		area.set_free()
