extends Node2D
# First In First Served
var parent
var targets = []
var targeting = []

func cal_min(min_range: float, max_range: float, offset: float = 5 , multiplier: float = 20) -> float:
	return (max_range - min_range + offset) * multiplier

func cal_max(max_range: float, offset: float = 10, multiplier: float = 20) -> float:
	return (max_range + offset) * multiplier

func _init():
	set_physics_process(true)
	parent = get_parent()

func set_area(min:int,max:int): # redo as groups
	$min/range.shape.radius = cal_min(parent.Data.Upgrades.MinRange, parent.Data.Upgrades.MaxRange)
	$max/range.shape.radius = cal_max(parent.Data.Upgrades.MaxRange)

func target() -> void:

	if !targets:
		return
	var invalid_targets = []

	for t in targets:
		if is_instance_valid(t):
			continue
		invalid_targets.append(t)

	# Remove invalid items after iteration
	for target in invalid_targets:
		targets.erase(target)
		targeting.erase(target)

	# Check if targeting capacity is reached
	if parent.Data["max_target_count"] <= targeting.size():
		return
	
	if targets.is_empty():
		return
	# Add a valid target to targeting
	var next_target = targets.pick_random()
	if next_target not in targeting:
		targeting.append(next_target)


func _on_max_area_entered(area):
	if !area.get_parent().is_in_group("minions"):
		return
	if !area.has_meta("owner"):
		return
	if targeting.size() < parent.Data["max_target_count"]:
		targeting.append(area)
	targets.append(area)
	notify_property_list_changed()

func _on_max_area_exited(area):
	targeting.erase(area)
	targets.erase(area)
	
func _on_min_area_entered(area):
	targeting.erase(area)
	targets.erase(area)

func _on_min_area_exited(area):
	if !area.get_parent().is_in_group("minions"):
		return
	if !area.has_meta("owner"):
		return
	targets.append(area)
