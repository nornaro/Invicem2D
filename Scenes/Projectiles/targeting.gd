extends Node2D


func _enter_tree() -> void:
	var min = CollisionShape2D.new()
	min.name = "range"
	min.shape = CircleShape2D.new()
	$min.add_child(min)
	var max = CollisionShape2D.new()
	max.name = "range"
	max.shape = CircleShape2D.new()
	$max.add_child(max)
