extends Area2D

func _ready() -> void:
	connect("area_exited",_on_area_entered)

func _on_area_entered(area: Node) -> void:
	if area.has_meta("projectile"):
		area.get_parent().set_free()
