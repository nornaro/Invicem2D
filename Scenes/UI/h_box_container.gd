extends Control

#func _ready() -> void:
	#connect("mouse_entered",undim)
	#connect("mouse_exited",dim)
	#
#func undim() -> void:
	#mouse_filter = Control.MOUSE_FILTER_STOP
	#add_theme_color_override("theme_override_style/fill",Color(0,0,0,0.5))
	#
	#
#func dim() -> void:
	#mouse_filter = Control.MOUSE_FILTER_IGNORE
	#add_theme_color_override("theme_override_style/fill",Color(0,0,0,0.9))
	#
	


#func _on_mouse_entered() -> void:
	#mouse_filter = Control.MOUSE_FILTER_STOP
	#add_theme_color_override("theme_override_style/fill",Color(0,0,0,0.5))
#
#
#func _on_mouse_exited() -> void:
	#mouse_filter = Control.MOUSE_FILTER_IGNORE
	#add_theme_color_override("theme_override_style/fill",Color(0,0,0,0.9))
#
#
#func _on_gui_input(event: InputEvent) -> void:
	#pass # Replace with function body.
