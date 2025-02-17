extends TextureButton

func _ready() -> void:
	connect("pressed", _on_pressed)
	
func _on_pressed() -> void:
	get_tree().call_group("Picker","module",tooltip_text)
