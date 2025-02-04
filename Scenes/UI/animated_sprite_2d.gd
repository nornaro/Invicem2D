extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#autoplay


func _on_option_button_mouse_entered() -> void:
	play()


func _on_option_button_mouse_exited() -> void:
	stop()
