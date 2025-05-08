extends Node
class_name GhostRush

@export var ghosts: int = 1
@export var speed: int = 1
@export var multiplier: int = 1
@onready var minion: Node = $".."

func _ready() -> void:
	minion.die = Callable(self, "die")

func die() -> void:
	if minion.Data.HP > 1:
		return
		"""
		Spawn x smaller tramsparent copy of itself, ghost prop, bonus speed
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
	#minion.Data.HP = minion.Data.max_hp * multiplier / 3
	#minion.update_hpbar.call()
