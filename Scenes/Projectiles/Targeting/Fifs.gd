extends Node2D

var targets = []
var targeting = []
var invalid = []
var parent

func cal_min(min_range: float, max_range: float, offset: float = 5, multiplier: float = 10) -> float:
	return (max_range - min_range + offset) * multiplier

func cal_max(max_range: float, offset: float = 5, multiplier: float = 10) -> float:
	return (max_range + offset) * multiplier

func _ready():
	parent = get_parent()
	set_process(true)

func _process(delta):
	$min/range.shape.radius = cal_min(parent.Data.Upgrades.MinRange, parent.Data.Upgrades.MaxRange)
	$max/range.shape.radius = cal_max(parent.Data.Upgrades.MaxRange)

	if !targets:
		return
	targeting.clear()
	for target in targets:
		if !is_instance_valid(target):
			targets.erase(target)
			targeting.erase(target)
			invalid.erase(target)
			continue
		if targeting.size() == parent.Data["max_target_count"]:
			break
		targets.append(target)

	if is_instance_valid(targets.front()):
		targeting.append(targets.front())

func _on_max_area_entered(area):
	if area.get_parent().is_in_group("minions"):
		if targeting.size() < Data["max_target_count"]:
			targeting.append(area)
		targets.append(area)

func _on_max_area_exited(area):
	if area.get_parent().is_in_group("minions"):
		targeting.erase(area)
		targets.erase(area)
	
func _on_min_area_entered(area):
	if area.get_parent().is_in_group("minions"):
		targeting.erase(area)
		invalid.append(area)

func _on_min_area_exited(area):
	if area.get_parent().is_in_group("minions"):
		invalid.erase(area)
