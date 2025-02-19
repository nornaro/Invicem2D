extends Node2D

@export var Data = {
	#"range" : [100.0, 300.0],
	#"angle": [-90.0, 90.0],
	#"max_target_count": 3
}

var targets = []
var targeting = []
var parent

func cal_min(min_range: float, max_range: float, offset: float = 5, multiplier: float = 10) -> float:
	return (max_range - min_range + offset) * multiplier

func cal_max(max_range: float, offset: float = 5, multiplier: float = 10) -> float:
	return (max_range + offset) * multiplier

func _ready():
	parent = get_parent()
	set_physics_process(true)
###unprocess
func _physics_process(delta):
	$min/range.shape.radius = cal_min(parent.Data.Upgrades.MinRange, parent.Data.Upgrades.MaxRange)
	$max/range.shape.radius = cal_max(parent.Data.Upgrades.MaxRange)

	if !targets:
		return
	for target in targets:
		if !is_instance_valid(target):
			targets.erase(target)
	for i: int in range(targeting.size()):
		targeting[i] = retarget(targeting[i])

func retarget(target):
	if targets.size() == 0:
		return null
	var new_target = targets.pick_random() 
	if !is_instance_valid(target):
		targets.erase(target)
		return new_target
	if randf() > 0.5:
		return new_target
	return target
		
func _on_max_area_entered(area):
	if !area.get_parent().is_in_group("minions"):
		return
	if !area.get_parent().has_meta("owner"):
		return
	if targeting.size() < parent.Data["max_target_count"]:
		targeting.append(area)
	targets.append(area)

func _on_max_area_exited(area):
	if area.get_parent().is_in_group("minions"):
		targeting.erase(area)
		targets.erase(area)
	
func _on_min_area_entered(area):
	if area.get_parent().is_in_group("minions"):
		targeting.erase(area)
		targets.erase(area)

func _on_min_area_exited(area):
	if area.get_parent().is_in_group("minions"):
		targets.append(area)
