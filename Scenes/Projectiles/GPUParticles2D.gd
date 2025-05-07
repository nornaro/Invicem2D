extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_material.scale_min = 0.1
	process_material.scale_max = 0.1
