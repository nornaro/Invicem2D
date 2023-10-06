@tool
extends Node2D

@export var zoom: float = 1.0

@onready var viewport: Viewport = get_parent()


func _process(delta: float) -> void:
	viewport.canvas_transform.origin = position


func get_zoom() -> float:
	return viewport.canvas_transform.get_scale().x


func set_zoom(value: float) -> void:
	var new_scale: float = value/get_zoom()
	viewport.canvas_transform = viewport.canvas_transform.scaled(Vector2(new_scale, new_scale))
