extends Area2D

func _ready() -> void:
	connect("area_exited",_on_area_exited)

func _on_area_exited(area: Area2D) -> void:
	if area.has_meta("projectile"):
		area.set_free()
