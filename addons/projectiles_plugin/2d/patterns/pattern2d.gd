@tool
extends Resource
class_name Pattern2D

@export var data: Array[PatternElem2D] : set = _set_data


func _set_data(d: Array[PatternElem2D]) -> void:
	data = d
	if data.size() and data.back() == null:
		data[data.size() - 1] = PatternElem2D.new()
	emit_signal("changed")
