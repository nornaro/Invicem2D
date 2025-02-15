extends Node2D
# First In First Served
var parent: Node
var targets: Array = []
var targeting: Array = []

func cal_min(min_range: float, max_range: float, offset: float = 5 , multiplier: float = 20) -> float:
	return (max_range - min_range + offset) * multiplier

func cal_max(max_range: float, offset: float = 10, multiplier: float = 20) -> float:
	return (max_range + offset) * multiplier

func _ready() -> void:
	set_physics_process(true)
	parent = get_parent()
###unprocess
func _physics_process(delta): # redo as groups
	$min/range.shape.radius = clamp(cal_min(parent.Data.Upgrades.MinRange, parent.Data.Upgrades.MaxRange),0.01,parent.Data.Upgrades.MaxRange)
	$max/range.shape.radius = cal_max(parent.Data.Upgrades.MaxRange)

	#if !targets:
		#return
	var invalid_targets = []

	for target: Node in targets:
		if target.is_in_group("minions"):
			continue
		invalid_targets.append(target)

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
	var next_target: Node = targets.pick_random()
	if next_target not in targeting:
		targeting.append(next_target)


func _on_max_area_entered(area) -> void:
	if !area.get_parent().is_in_group("minions"):
		return
	if !area.has_meta("owner"):
		return
	if targeting.size() < parent.Data["max_target_count"]:
		targeting.append(area)
	targets.append(area)
	notify_property_list_changed()

func _on_max_area_exited(area) -> void:
	targeting.erase(area)
	targets.erase(area)
	
func _on_min_area_entered(area) -> void:
	targeting.erase(area)
	targets.erase(area)

func _on_min_area_exited(area) -> void:
	if !area.get_parent().is_in_group("minions"):
		return
	if !area.has_meta("owner"):
		return
	targets.append(area)
