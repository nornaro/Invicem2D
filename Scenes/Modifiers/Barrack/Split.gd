extends Node
class_name Split

@export var split_count: int = 1
@export var dupes: int = 2
@onready var minion: Minion = $".."

func _ready() -> void:
	minion.die = Callable(self, "die")
	minion.extra = Callable(self, "extra")

func die() -> void:
	if minion.Data.HP > 1:
		return
	if split_count > 0:
		var data:Dictionary = minion.Data
		split_count -= 1
		await split(data)
	die_fr.call()
		
func split(data:Dictionary) -> void:
	for splits:int in range(dupes):
		data.Size = clampi(data.Size - dupes,1,16)
		data.max_hp = roundi(data.max_hp / 3)
		data.HP += data.max_hp
		data.Size = clampi(data.Size - dupes,1,16)
		data.global_position += Vector2(randi_range(-20,20),randi_range(-20,20))
		get_tree().call_group("Barrack","spawn",data)

func die_fr() -> void:
	minion.dead = true
	minion.remove_from_group("minions")
	minion.linear_velocity = Vector2.ZERO
	minion.Sprite.connect("animation_looped", minion.queue_free)
	minion.Sprite.play("Dying")
	await get_tree().create_timer(10).timeout
	minion.area.death()
	minion.area.queue_free()

func extra(_arguments: Dictionary) -> void:
	await get_tree().create_timer(10).timeout
	minion.dead = false
