extends Panel


func _on_confirm_pressed() -> void:
	get_tree().quit()


func _on_cancel_pressed() -> void:
	hide()
