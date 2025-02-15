extends Button


func _on_pressed() -> void:
	get_tree().root.get_children()[0].start()
	get_parent().hide()
	pass # Replace with function body.

func _on_mouse_entered() -> void:
	$MeshInstance2D.show()


func _on_mouse_exited() -> void:
	$MeshInstance2D.hide()
