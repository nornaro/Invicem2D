extends Area2D

func _on_area_exited(area: Area2D) -> void:
	area.set_free()
	if area.has_meta("projectile"):
		area.get_parent().queue_free()

func _process(delta: float) -> void:
	arelerp()
