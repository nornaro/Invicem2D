extends MeshInstance2D

@onready var camera = $".."

func _process(delta: float) -> void:
	var mouse_pos = camera.get_viewport().get_mouse_position()
	var camera_rect = camera.get_viewport().get_visible_rect()
	var csx = camera.get_viewport().size.x/100
	var csy = camera.get_viewport().size.y/100
	
	if mouse_pos.x - camera_rect.position.x <= csx:
		print("Left")
	if camera_rect.position.x + camera_rect.size.x - mouse_pos.x <= csx:
		print("Right")
	if mouse_pos.y - camera_rect.position.y <= csy:
		print("Top")
	if camera_rect.position.y + camera_rect.size.y - mouse_pos.y <= csy:
		print("Bottom")
	
	position = camera.get_local_mouse_position()
