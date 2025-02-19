extends Node

class_name ShieldComponent

var shield: int = 0
var max_shield: int = 0
var shield_bar: Node
var shield_hit_effect: Node
var depleted_animation: Node

@export var initialize: Callable = func(shield_value: int, max_shield_value: int, bar: Node, hit_effect: Node, depleted: Node) -> void:
	shield = shield_value
	max_shield = max_shield_value
	shield_bar = bar
	shield_hit_effect = hit_effect
	depleted_animation = depleted
	update_visuals.call()

@export var take_damage: Callable = func(damage: int) -> int:
	if shield == 0:
		return damage

	shield_hit_effect.self_modulate.a = 1
	var remaining_damage: int = max(damage - shield, 0)
	shield = max(shield - damage, 0)
	shield_bar.value = shield

	if shield == 0:
		deplete.call()

	update_visuals.call()
	return remaining_damage

@export var deplete: Callable = func() -> void:
	shield_bar.hide()
	depleted_animation.show()
	depleted_animation.play("default")

@export var update_visuals: Callable = func() -> void:
	var mod: float = clamp(float(shield) / 10000.0, 0.05, 1)
	shield_hit_effect.self_modulate.a = mod
	if shield > 0:
		shield_bar.show()
