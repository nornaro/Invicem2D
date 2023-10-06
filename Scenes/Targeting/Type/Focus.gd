extends Node2D

@export var Data = {
	"range" : [100.0, 300.0],
	"angle": [-90.0, 90.0],
	"max_target_count": 3,
	"focus": {}
}

var targets = []
var targeting = []

func _ready():
	set_process(true)
	$min/range.shape.radius = float(Data["range"][0])
	$max/range.shape.radius = float(Data["range"][1])
	if get_parent() is Node2D:
		$min.scale = Vector2(1/get_parent().scale.x,1/get_parent().scale.y)
		$max.scale = Vector2(1/get_parent().scale.x,1/get_parent().scale.y)

func _process(delta):
	retarget()

func calculate_score(target) -> float:
	var score = 0.0
	for attribute in Data["focus"].keys():
		var attribute_value = target.Data[attribute] if attribute in target.Data else 0
		score += attribute_value * Data["focus"][attribute]
	return score

func compare_targets(a, b) -> int:
	return sign(calculate_score(b) - calculate_score(a))

func retarget():
	if !targets:
		return
	targeting.clear()
	for target in targets:
		if !is_instance_valid(target):
			targets.erase(target)
	if Data["max_target_count"] <= targeting.size():
		return
	targets.sort_custom(compare_targets)

	for target in targets: # Adding the highest priority targets to the targeting list
		if is_instance_valid(target) and targeting.size() < Data["max_target_count"]:
			targeting.append(target)

func gather_focus_attributes():
	var all_keys = []
	for target in targets:
		for key in target.Data.keys():
			if key not in all_keys:
				all_keys.append(key)
	for key in all_keys:
		if key not in Data["focus"]:
			Data["focus"][key] = 0  # Assigning default value of 0

func _on_max_area_entered(area):
	if area.get_parent().is_in_group("minions"):
		targets.append(area)
		gather_focus_attributes()

func _on_max_area_exited(area):
	if area.get_parent().is_in_group("minions"):
		targets.erase(area)

func _on_min_area_entered(area):
	if area.get_parent().is_in_group("minions"):
		targets.erase(area)

func _on_min_area_exited(area):
	if area.get_parent().is_in_group("minions"):
		targets.append(area)
