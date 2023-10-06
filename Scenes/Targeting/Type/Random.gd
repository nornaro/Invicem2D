extends Node2D

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

func _process(delta):
	if !targets:
		return
	for target in targets:
		if !is_instance_valid(target):
			targets.erase(target)
	for i in range(targeting.size()):
		targeting[i] = retarget(targeting[i])

func retarget(target):
	var new_target = get_random_target()
	if !is_instance_valid(target):
		targets.erase(target)
		return new_target
	if randf() > 0.5:
		return new_target
	return target
				
func get_random_target() -> Object:
	if targets.size() == 0:
		return null
	return targets[randi() % targets.size()]
		
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
		targets.erase(area)

func _on_min_area_exited(area):
	if area.get_parent().is_in_group("minions"):
		targets.append(area)
