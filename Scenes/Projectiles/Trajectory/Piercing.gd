extends AnimatedSprite2D

var Data: Dictionary = {}
var target = null  
var linear_velocity:Vector2
var freedom: bool = false
var collide: bool = true
@onready var sprite:AnimatedSprite2D = $"."
@onready var area: Area2D = $Area2D

func _enter_tree() -> void:
	for meta:String in sprite.sprite_frames.get_meta_list():
		Data[meta] = sprite.sprite_frames.get_meta(meta)
	

func set_free() -> void:
	freedom = true

func _physics_process(_delta: float) -> void:
	position += linear_velocity
	if !freedom:
		return
	sprite.self_modulate.a = lerp(sprite.self_modulate.a,0.0,0.5)
	if sprite.self_modulate.a <= 0.1:
		get_parent().queue_free()

func _ready():
	set_physics_process(true)
	if !target:
		queue_free()
		return
	var tp = target.global_position
	area.add_to_group("projectile")
	var speed = Data.ProjectileSpeed + 10
	sprite.scale *= 0.5+0.5/Data.Size
	position += Vector2(1,0) * randf_range(-Data.Size,Data.Size)*2
	linear_velocity = ((
		(tp-global_position) * speed + 
		target.get_parent().linear_velocity*sqrt(speed)*5).normalized() * speed)
	var spread_range = Data.Spread * randf_range(1,2)
	linear_velocity += Data.Spread + spread_range

func hit():
	Data.Damage -= 1
	if Data.Damage < 1:
		set_free()
		queue_free()
