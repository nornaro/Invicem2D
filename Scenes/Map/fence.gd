extends RigidBody2D

func _ready() -> void:
	connect("body_entered",_on_area_entered)

func _on_area_entered(body: Node) -> void:
	if body.has_meta("projectile"):
		body.set_free()


func _on_body_exited(body: Node) -> void:
	print(_on_body_exited)
	pass # Replace with function body.


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	print(_on_body_shape_entered)
	pass # Replace with function body.


func _on_body_shape_exited(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	print(_on_body_shape_exited)
	pass # Replace with function body.


func _on_sleeping_state_changed() -> void:
	print(_on_sleeping_state_changed)
	pass # Replace with function body.
