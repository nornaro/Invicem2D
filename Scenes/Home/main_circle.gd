extends Control


func _on_pressed() -> void:
	get_tree().call_group("MainCircle","hide")
	show()
