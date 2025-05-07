extends MeshInstance2D

var fade:bool = false

func _ready() -> void:
	if mesh is QuadMesh:
		mesh.size = get_viewport_rect().size

func _process(delta: float) -> void:
	print(name)
	if !fade:
		return
	#get_tree().get_first_node_in_group("Home").queue_free()
	self_modulate.a += delta
	if self_modulate.a > 0.999:
		queue_free()
