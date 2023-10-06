@tool
extends EditorInspectorPlugin

@export var editor_plugin: EditorPlugin

signal pattern_selected(pattern: Pattern2D)


func _can_handle(object):
	if object is Pattern2D:
		emit_signal("pattern_selected", object)
		return true
	return false
