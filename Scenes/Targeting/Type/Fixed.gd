extends Node2D
# First In First Served
@export var Data = {
	"range" : [100.0, 300.0],
	"angle": [-90.0, 90.0],
	"max_target_count": 3
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

func _process(delta): # redo as groups
	if !targets:
		return
	var invalid_targets = []

	for target in targets:
		if is_instance_valid(target):
			continue
		invalid_targets.append(target)

	# Remove invalid items after iteration
	for target in invalid_targets:
		targets.erase(target)
		targeting.erase(target)

	# Check if targeting capacity is reached
	if Data["max_target_count"] <= targeting.size():
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
	if targeting.size() < Data["max_target_count"]:
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
