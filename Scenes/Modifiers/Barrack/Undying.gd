extends Node
class_name Undying

@export var duration: int = 1
@onready var minion: Node = $".."

func _ready() -> void:
	minion.die = Callable(self, "die")

func die() -> void:
	if minion.Data.hp > 1:
		return
	minion.Sprite.self_modulate = Color.RED
	await get_tree().create_timer(duration,true,true)
	minion.dead = 666
	remove_from_group("minions")
	minion.linear_velocity = Vector2.ZERO
	minion.Sprite.connect("animation_looped", queue_free)
	minion.Sprite.play("Dying")
	await get_tree().create_timer(10).timeout
	minion.area.death()
	minion.area.queue_free()
