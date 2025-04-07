extends Label

func _physics_process(delta: float) -> void:
	text = str(Global.counter)
