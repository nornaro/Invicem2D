extends Area2D

var freedom: bool = false
var collide: bool = true

func _enter_tree() -> void:
	var collision:CollisionShape2D = CollisionShape2D.new()
	collision.name = "collision"
	collision.shape = CircleShape2D.new()
	collision.shape.radius = 10
	collision.disabled = !collide
	add_child(collision)
	var sprite:AnimatedSprite2D = $"../AnimatedSprite2D"
	for meta:String in sprite.sprite_frames.get_meta_list():
		get_parent().Data[meta] = sprite.sprite_frames.get_meta(meta)
	

func set_free() -> void:
	freedom = true

func _physics_process(_delta: float) -> void:
	if !freedom:
		return
	$"../AnimatedSprite2D".self_modulate.a = lerp($"../AnimatedSprite2D".self_modulate.a,0.0,0.5)
	if $"../AnimatedSprite2D".self_modulate.a <= 0.01:
		get_parent().queue_free()
