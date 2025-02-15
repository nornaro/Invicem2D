extends RigidBody2D

func _ready() -> void:
	connect("body_entered",_on_area_entered)

func _on_area_entered(body: Node) -> void:
	if body.has_meta("projectile"):
		body.set_free()
