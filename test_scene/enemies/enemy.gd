extends CharacterBody2D

@export var shoot_cd: float = 2.0
@export var max_hp: float = 100.0
@export var move_speed: float = 80.0
@export var move_dir_refresh_t: float = 2.0

@onready var hp: float = max_hp

var shoot_time: float = 0.0
var move_dir_time: float = 0.0
var curr_pattern: int = 0
var move_dir: Vector2 = Vector2(1.0, 0.0)


func _process(delta: float) -> void:
	shoot_time += delta
	if shoot_time >= shoot_cd:
		shoot_time -= shoot_cd
		$Patterns.get_child(curr_pattern).fire_pattern()
		curr_pattern = (curr_pattern + 1)%$Patterns.get_child_count()
	
	move_dir_time += delta
	if move_dir_time >= move_dir_refresh_t:
		move_dir_time -= move_dir_refresh_t
		move_dir = Vector2(1.0, 0.0).rotated(randf()*2.0*PI)
	
	velocity = move_dir*move_speed
	move_and_slide()


func damage(d: float) -> void:
	hp -= d
	if hp <= 0.0:
		queue_free()
