extends TextureButton

@export var right: String
@export var left: String


func _ready() -> void:
	connect("gui_input",on_pressed)
	
func on_pressed(event) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_RIGHT:
				get_tree().call_group("selected","upgrade",right,left)
			MOUSE_BUTTON_LEFT:
				get_tree().call_group("selected","upgrade",left,right)
