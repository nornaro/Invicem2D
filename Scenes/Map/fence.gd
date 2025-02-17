extends Area2D

func _ready() -> void:
	connect("area_entered",_on_area_entered)
