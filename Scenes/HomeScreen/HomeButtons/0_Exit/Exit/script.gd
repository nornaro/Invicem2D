extends Node

func _ready() -> void:
	self.connect("pressed", _on_pressed)
	
	
func _on_pressed() -> void:
	get_tree().quit()
