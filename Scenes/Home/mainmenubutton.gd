extends Button


func _on_pressed() -> void:
	match name:
		"Start":
			get_tree().root.get_children()[0].start()
			get_parent().hide()
		"Exit":
			get_tree().quit()
		"Style":
			pass


func _on_mouse_entered() -> void:
	$MeshInstance2D.show()


func _on_mouse_exited() -> void:
	$MeshInstance2D.hide()
