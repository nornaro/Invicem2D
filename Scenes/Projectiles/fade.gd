extends Area2D

var freedom = false

func set_free():
	freedom = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !freedom:
		return
	$"../AnimatedSprite2D".self_modulate.a = lerp($"../AnimatedSprite2D".self_modulate.a,0.0,0.1)
	if $"../AnimatedSprite2D".self_modulate.a <= 0:
		get_parent().queue_free()
