extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	autoplay
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_option_button_mouse_entered() -> void:
	play()


func _on_option_button_mouse_exited() -> void:
	stop()
