extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready():
	process_material.scale_min = 0.1
	process_material.scale_max = 0.1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
