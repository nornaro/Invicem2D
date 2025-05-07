extends Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("timeout",_on_ASPD_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_ASPD_timeout() -> void:
	get_tree().call_group("Shooter","_on_ASPD_timeout")
