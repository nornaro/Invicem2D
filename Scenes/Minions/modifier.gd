extends Node
class_name RevivalModifier

@export var revive_count: int = 2
@export var revive_hp_threshold: float = 0.1
@export var revive_hp_restore: float = 1

@onready var minion: Node = $".."

func _ready() -> void:
	minion.hurt = Callable(self, "hurt")

func hurt(data: Dictionary) -> void:
	if minion.dead:
		return
	
	var damage: int = minion.damage_component.calculate_damage.call(data, minion.Data)
	damage = minion.shield_component.take_damage.call(damage)
	
	if damage > 0:
		minion.Data.ho -= damage
		minion.update_hpbar.call()
	
	if minion.Data.hp <= minion.Data.max_hp * revive_hp_threshold:
		check_revival()

func check_revival() -> void:
	if revive_count == 0:
		minion.die.call()
	revive_count -= 1
	minion.Data.hp = minion.Data.max_hp * revive_hp_restore
	minion.update_hpbar.call()
	return
