extends Camera2D

# Configurable zoom speed and limits.
var zoom_speed: float = 0.1
var min_zoom: float = 0.5
var max_zoom: float = 2.0

# Variables to handle middle-click panning
var dragging: bool = false
var drag_start_pos: Vector2

func _input(event):
	if event is InputEventMouseButton:
		# Check for scroll wheel movement for zooming
		if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			var direction = 1 if event.button_index == MOUSE_BUTTON_WHEEL_UP else -1
			var new_zoom = clamp(zoom.x + direction * zoom_speed, min_zoom, max_zoom)
			zoom = Vector2(new_zoom, new_zoom)
		
		# Check for middle mouse button pressed to start dragging
		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.is_pressed():
				dragging = true
				drag_start_pos = event.global_position
			else:
				dragging = false

	elif event is InputEventMouseMotion and dragging:
		var drag_offset = event.global_position - drag_start_pos
		global_position -= drag_offset
		drag_start_pos = event.global_position  # Update for continuous dragging
