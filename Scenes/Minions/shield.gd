extends Node

class_name ShieldComponent

var shield: Node
var max_shield: int = 0
var shield_bar: Node
var shield_hit_effect: Node
var depleted_animation: Node

@export var initialize: Callable = func(max_shield_value: float, bar: Node, hit_effect: Node, depleted: Node, shiled_node: Node) -> void:
	if max_shield_value == 0:
		shiled_node.hide()
		bar.hide()
	max_shield = max_shield_value
	shield_bar = bar
	shield_bar.value = max_shield
	shield = shiled_node
	shield_hit_effect = hit_effect
	depleted_animation = depleted
	update_visuals.call()

@export var take_damage: Callable = func(damage: int) -> int:
	shield_hit_effect.self_modulate.a = 1
	var remaining_damage: int = max(damage - shield_bar.value, 0)
	shield_bar.value = max(shield_bar.value - damage, 0)

	if shield_bar.value == 0:
		deplete.call()

	update_visuals.call()
	return remaining_damage

@export var deplete: Callable = func() -> void:
	shield.hide()
	shield_bar.hide()
	depleted_animation.show()
	depleted_animation.play("default")

@export var update_visuals: Callable = func() -> void:
	var mod: float = clamp(float(shield_bar.value) / 10000.0, 0.05, 1)
	shield_hit_effect.self_modulate.a = mod
	if shield_bar.value > 0:
		shield.show()
		shield_bar.hide()
