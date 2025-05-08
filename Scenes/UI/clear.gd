extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("pressed",clear)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func clear() -> void:
	get_tree().call_group("minions","queue_free")
