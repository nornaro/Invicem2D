extends TextEdit

func _input(_event: InputEvent) -> void:
	if !Input.is_action_pressed("Ctrl"):
		return
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_DOWN):
		theme.default_font_size -= 1
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP):
		theme.default_font_size += 1
