extends Node2D

var is_firing = false

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		is_firing = !is_firing
		$GPUParticles2D.emitting = is_firing
