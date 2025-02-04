extends Panel

func _ready() -> void:
	connect("mouse_entered", _undim)
	connect("mouse_exited", _dim)

func _undim() -> void:
	self_modulate.a = 0.4
	modulate.a = 0.8

func _dim() -> void:
	self_modulate.a = 0.1
	modulate.a = 0.4
