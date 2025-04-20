extends Node

class_name ShieldComponent

var shield: Node
var max_shield: int = 0
var shield_bar: Node
var shield_hit_effect: Node
var depleted_animation: Node
var shield_aura: Node

@export var initialize: Callable = func(max_shield_value: int, bar: Node, aura: Node, depleted: Node, shiled_node: Node, hit_effect: AnimationPlayer) -> void:
	if max_shield_value == 0:
		shiled_node.hide()
		bar.hide()
	max_shield = max_shield_value
	shield_bar = bar
	shield_bar.value = max_shield
	shield = shiled_node
	shield_hit_effect = hit_effect
	depleted_animation = depleted
	shield_aura = aura
	shield_aura.play("default")
	update_visuals.call()

@export var take_damage: Callable = func(damage: int) -> int:
	if shield_bar.value == 0:
		return damage

	shield_hit_effect.play("hit")
	
	var remaining_damage: int = max(damage - shield_bar.value, 0)
	shield_bar.value = max(shield_bar.value - damage, 0)

	if shield_bar.value == 0:
		deplete.call()
		return remaining_damage

	update_visuals.call()
	return remaining_damage

@export var deplete: Callable = func() -> void:
	shield_aura.hide()
	shield_bar.hide()
	depleted_animation.show()
	depleted_animation.play("default")

@export var update_visuals: Callable = func() -> void:
	if shield_bar.value > 0:
		shield.show()
		return
	shield_bar.hide()
