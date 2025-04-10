extends Node

class_name DamageComponent

@export var calculate_damage: Callable = func(data: Dictionary, target_data: Dictionary) -> int:
	var damage: int = data.Damage * data.base_damage
	var crit: int = data.Crit - target_data.get("CritResist", 0)

	if randi_range(0, 100) < crit * data.crit_chance:
		damage *= 1 + randi_range(1, ceil(crit / data.crit_multi))

	return apply_defense.call(damage, data, target_data)

@export var apply_defense: Callable = func(damage: int, data: Dictionary, target_data: Dictionary) -> int:
	var defense: int = max(target_data.Defense - data.Penetration, 0)

	if data.has("armor"):
		var armor_factor: float = data.armor[1]
		if data.armor[0]:
			return max(damage - defense * armor_factor, 0)
		return max(damage * (1 - armor_factor * defense / 100), 0)

	return damage
