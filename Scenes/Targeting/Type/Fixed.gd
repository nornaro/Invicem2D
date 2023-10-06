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
	for target in targets:
		if !is_instance_valid(target):
			targets.erase(target)
			targeting.erase(target)
	for target in targeting:
		if !is_instance_valid(target):
			targets.erase(target)
			targeting.erase(target)
	if  Data["max_target_count"] <= targeting.size():
		return
	if !targets:
		return
	targeting.append(targets[0])

func _on_max_area_entered(area):
	if area.get_parent().is_in_group("minions"):
		if targeting.size() < Data["max_target_count"]:
			targeting.append(area)
		targets.append(area)
		notify_property_list_changed()

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
