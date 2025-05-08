extends Node
class_name Gemini

@export var delay: int = 1
@export var ankh: int = 1
@export var multiplier: int = 1
@onready var minion: Node = $".."

func _ready() -> void:
	minion.die = Callable(self, "die")

func die() -> void:
	if minion.Data.hp > 1:
		return
		"""
		spawn double, with less 60-70-80% hp
		"""
	#minion.dead = true
	#remove_from_group("minions")
	#minion.linear_velocity = Vector2.ZERO
	#minion.Sprite.connect("animation_looped", queue_free)
	#minion.Sprite.play("Dying")
	#await get_tree().create_timer(10).timeout
	#if ankh <= 0:
		#minion.area.death()
		#minion.area.queue_free()
		#return
	#minion.Data.hp = minion.Data.max_hp * multiplier / 3
	#minion.update_hpbar.call()
