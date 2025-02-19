extends Camera2D

var zoom_speed: float = 0.1
var min_zoom: float = 0.8
var max_zoom: float = 2
var new_zoom: float

# Variables to handle middle-click panning
var dragging: bool = false
var drag_start_pos: Vector2

func _ready() -> void:
	add_to_group("Camera2")
	make_current()
	zoom = Vector2.ONE * (min_zoom+max_zoom)/2
	new_zoom = zoom.x

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			var direction: float = Input.get_axis("MWD","MWU")
			new_zoom = clamp(new_zoom + direction * zoom_speed, min_zoom, max_zoom)
			
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			dragging = false
			if event.is_pressed():
				dragging = true
				drag_start_pos = event.global_position
	if event is InputEventMouseMotion and dragging:
		var drag_offset: Vector2 = event.global_position - drag_start_pos
		global_position -= drag_offset
		drag_start_pos = event.global_position

func _process(delta: float) -> void:
	zoom = Vector2.ONE * lerpf(zoom.x,new_zoom,10*delta)
