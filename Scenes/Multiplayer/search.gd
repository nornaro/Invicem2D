extends TextEdit

func _ready() -> void:
	connect("text_changed", _on_text_changed)


func _on_text_changed() -> void:
	pass # Replace with function body.
