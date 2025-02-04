extends Button


func _ready() -> void:
	connect("pressed", _on_pressed)
	
	
func _on_pressed() -> void:
	get_tree().call_group("MPHUD","hide")
