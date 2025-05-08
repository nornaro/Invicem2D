extends Node
class_name Split

@export var split_count: int = 1
@export var dupes: int = 2
@onready var minion: Minion = $".."

func _ready() -> void:
	minion.die = Callable(self, "die")
	minion.extra = Callable(self, "extra")
	if !minion.Data.has("split_count"):
		minion.Data["split_count"] = split_count
	get_tree()

func die() -> void:
	if minion.Data.hp > 1:
		return
	if minion.Data.split_count > 0:
		split(minion.Data)
	die_fr.call()
		
func split(data:Dictionary) -> void:
	data.split_count -= 1
	var spawner: Barrack = Barrack.new()
	spawner._ready()
	for splits:int in range(dupes):
		data.HP = clampi(data.HP - dupes,1,16)
		data.Size = clampi(data.Size - dupes,1,16)
		data.global_position = minion.global_position + Vector2(randi_range(-20,20),randi_range(-20,20))
		data.dead = 1
		spawner.spawn(data)

func die_fr() -> void:
	minion.Data.dead = 1
	minion.remove_from_group("minions")
	minion.linear_velocity = Vector2.ZERO
	minion.Sprite.connect("animation_looped", minion.queue_free)
	minion.Sprite.play("Dying")
	await get_tree().create_timer(10).timeout
	minion.area.death()
	minion.area.queue_free()

func extra(_arguments: Dictionary) -> void:
	get_tree()
