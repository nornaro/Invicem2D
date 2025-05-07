extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("pressed",freeit)
	
func freeit() -> void:
	get_tree().get_first_node_in_group(name).queue_free()
