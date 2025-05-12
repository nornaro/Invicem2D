extends Node2D
class_name Fixed_targeting

# First In First Served
var parent: Node
var in_targeting_range: Array[Node]
var targets: Array[Node] = []
var targeting: Array[Node] = []

func cal_min(min_range: float, max_range: float, offset: float = 5 , multiplier: float = 20) -> float:
	return (max_range - min_range + offset) * multiplier

func cal_max(max_range: float, offset: float = 10, multiplier: float = 20) -> float:
	return (max_range + offset) * multiplier

func _ready() -> void:
	set_physics_process(true)
	parent = get_parent()
	$max.connect("area_entered",_on_max_area_entered)
	$max.connect("area_exited",_on_max_area_exited)
	$min.connect("area_entered",_on_min_area_entered)
	$min.connect("area_exited",_on_min_area_exited)

func set_range() -> void:
	var range:Array = [parent.Data.Upgrades.MinRange,parent.Data.Upgrades.MaxRange]
	$min/range.shape.radius = clamp(cal_min(range[0], range[1]),0.01,range[1])
	$max/range.shape.radius = cal_max(range[1])

func retarget() -> void:
	var free:int = parent.Data["max_target_count"] - targeting.size()
	if free <= 0:
		return
	for i in range(free):
		if in_targeting_range.is_empty():
			break  # Exit the loop if the array is empty
		var next_target: MinionArea = in_targeting_range.pick_random()
		if next_target == null:
			continue
		if next_target.get_parent().dead > 0:
			continue
		in_targeting_range.erase(next_target)
		targeting.append(next_target)

func _on_max_area_entered(area: Area2D) -> void:
	if area is not MinionArea:
		return
	if !area.has_meta("owner"):
		return
	in_targeting_range.append(area)
	area.connect("dead",death)
	retarget()
	
func _on_min_area_entered(area: Area2D) -> void:
	if area is not MinionArea:
		return
	targeting.erase(area)
	in_targeting_range.erase(area)
	retarget()

func _on_max_area_exited(area: Area2D) -> void:
	if area is not MinionArea:
		return
	targeting.erase(area)
	in_targeting_range.erase(area)
	retarget()

func _on_min_area_exited(area: Area2D) -> void:
	if area is not MinionArea:
		return
	if !area.has_meta("owner"):
		return
	in_targeting_range.append(area)
	retarget()
	
func death(area:Area2D) -> void:
	targeting.erase(area)
	in_targeting_range.erase(area)
	retarget()
	
