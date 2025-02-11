extends Node
	
func _ready() -> void:
	get_parent().get_parent().connect("pressed", _on_pressed)

func _on_pressed() -> void:
	get_tree().call_group("MPHUD","show")
