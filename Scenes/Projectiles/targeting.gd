extends Node2D
	
func _enter_tree() -> void:
	var min_range:CollisionShape2D = CollisionShape2D.new()
	min_range.name = "range"
	min_range.shape = CircleShape2D.new()
	$min.add_child(min_range)
	var max_range:CollisionShape2D = CollisionShape2D.new()
	max_range.name = "range"
	max_range.shape = CircleShape2D.new()
	$max.add_child(max_range)
