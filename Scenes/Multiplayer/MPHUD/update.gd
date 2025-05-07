extends Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("timeout",_on_timeout)
	start()
	set_autostart(true)
	
func _on_timeout() -> void:
	get_tree().call_group(name,name.to_lower())
