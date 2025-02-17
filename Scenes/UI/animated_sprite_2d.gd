extends AnimatedSprite2D


func _ready() -> void:
	$"..".connect("mouse_entered",_on_option_button_mouse_entered)
	$"..".connect("mouse_exited",_on_option_button_mouse_exited)


func _on_option_button_mouse_entered() -> void:
	play()


func _on_option_button_mouse_exited() -> void:
	stop()
