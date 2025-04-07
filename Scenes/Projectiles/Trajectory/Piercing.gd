extends AnimatedSprite2D

var Data: Dictionary = {}
var target:Node
var linear_velocity:Vector2
var freedom: bool = false
var collide: bool = true
@onready var sprite:AnimatedSprite2D = $"."
@onready var area: Area2D = $Area2D
var pierce:int = 0


func _enter_tree() -> void:
	pierce = Data.Spawn.Damage -1
	for meta:String in sprite.sprite_frames.get_meta_list():
		Data[meta] = sprite.sprite_frames.get_meta(meta)
	

func set_free() -> void:
	freedom = true

func _physics_process(_delta: float) -> void:
	position += linear_velocity * 60 / Engine.physics_ticks_per_second
	if !freedom:
		return
	sprite.self_modulate.a = lerp(sprite.self_modulate.a,0.0,0.5)
	if sprite.self_modulate.a <= 0.1:
		queue_free()
		Global.counter -= 1

func _ready() -> void:
	Global.counter += 1
	set_physics_process(true)
	if !target:
		Global.counter -= 1
		queue_free()
		return
	var tp:Vector2 = target.global_position
	area.add_to_group("projectile")
	var speed:int = Data.ProjectileSpeed + 10
	sprite.scale *= 0.5+0.5/Data.Size
	position += Vector2(1,0) * randf_range(-Data.Size,Data.Size)*2
	linear_velocity = ((
		(tp-global_position) * speed + 
		target.get_parent().linear_velocity*sqrt(speed)*60).normalized() * speed)
	var spread_range:Vector2 = Data.Spread * randf_range(1,2)
	linear_velocity += Data.Spread + spread_range

func hit() -> void:
	pierce -= 1
	if !pierce:
		Global.counter -= 1
		queue_free()
