extends Area2D

var freedom = false
var collide = true

func _enter_tree() -> void:
	var collision = CollisionShape2D.new()
	collision.name = "collision"
	collision.shape = CircleShape2D.new()
	collision.shape.radius = 10
	collision.disabled = !collide
	add_child(collision)

func set_free():
	freedom = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !freedom:
		return
	$"../AnimatedSprite2D".self_modulate.a = lerp($"../AnimatedSprite2D".self_modulate.a,0.0,0.1)
	#print($"../AnimatedSprite2D".self_modulate.a)
	if $"../AnimatedSprite2D".self_modulate.a <= 0.01:
		get_parent().queue_free()
