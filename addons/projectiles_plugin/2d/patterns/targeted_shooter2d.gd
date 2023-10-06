extends PatternShooter2D
class_name TargetedShooter2D

@export var group_name: String = ""

@onready var target: Node2D = get_tree().get_first_node_in_group(group_name)


func _physics_process(delta: float) -> void:
	rotation = Vector2(1.0, 0.0).angle_to(target.global_position - global_position)
