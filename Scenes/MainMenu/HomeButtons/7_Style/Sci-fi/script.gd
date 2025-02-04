extends TextureButton


func _ready() -> void:
	add_to_group("Style")
	connect("pressed", _on_pressed)

func _on_pressed() -> void:
	Global.style = name
	get_tree().call_group("Style","set_self_modulate",Color.WHITE)
	self_modulate = Color.GREEN
