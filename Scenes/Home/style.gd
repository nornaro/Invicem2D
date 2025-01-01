extends TextureButton


func _on_pressed() -> void:
	var root = get_tree().root.get_children()[0]
	root.style = name
	#$"../../..".style = name
	#$"../../..".notify_property_list_changed()
	get_tree().call_group("Style","set_self_modulate",Color.WHITE)
	self_modulate = Color.GREEN
