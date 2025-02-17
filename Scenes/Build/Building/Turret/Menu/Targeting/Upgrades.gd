extends Node2D

var focus: String = "max_hp"
var targets = []
var targeting = []
var parent

func cal_min(min_range: float, max_range: float, offset: float = 5, multiplier: float = 10) -> float:
	return (max_range - min_range + offset) * multiplier

func cal_max(max_range: float, offset: float = 5, multiplier: float = 10) -> float:
	return (max_range + offset) * multiplier

func _ready():
	set_physics_process(true)
	parent = get_parent()
###unprocess
func _physics_process(delta: float) -> void:
	$min/range.shape.radius = cal_min(parent.Data.Upgrades.MinRange, parent.Data.Upgrades.MaxRange)
	$max/range.shape.radius = cal_max(parent.Data.Upgrades.MaxRange)
	retarget()

func retarget():
	if !targets:
		return
	
	targeting.clear()
	for target in targets:
		if !is_instance_valid(target):
			targets.erase(target)

	if parent.Data["max_target_count"] <= targeting.size():
		return
	var targetdict: Dictionary
	for target in targets:
		if !is_instance_valid(target):
			targets.erase(target)
			continue
		targetdict[target.get_parent().Data[focus]] = target
	
	if targetdict.is_empty():
		return
	var targetarray = targetdict.keys()
	targetarray.sort()
	targeting.append(targetdict[targetarray.back()])
	targets.append(targetdict[targetarray.back()])

func _on_max_area_entered(area):
	if area.get_parent().is_in_group("minions"):
		targets.append(area)

func _on_max_area_exited(area):
	if area.get_parent().is_in_group("minions"):
		targets.erase(area)

func _on_min_area_entered(area):
	if area.get_parent().is_in_group("minions"):
		targets.erase(area)

func _on_min_area_exited(area):
	if area.get_parent().is_in_group("minions"):
		targets.append(area)
