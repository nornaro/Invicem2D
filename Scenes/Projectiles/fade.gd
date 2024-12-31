extends Area2D

var freedom = false

func set_free(set_it_free):
	freedom = set_it_free

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$"../AnimatedSprite2D".self_modulate.a = lerp($"../AnimatedSprite2D".self_modulate.a,0,0.01)
