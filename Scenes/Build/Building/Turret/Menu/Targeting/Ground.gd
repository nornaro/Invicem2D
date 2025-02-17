extends Node2D


@export var Data = {
	#"range" : [100.0, 300.0],
	#"angle": [-90.0, 90.0],
	#"max_target_count": 3,
}
var targets = {}
var targeting = []
var target = Area2D.new()
var minions_in_max_area = []

func cal_min(min_range: float, max_range: float, offset: float = 5, multiplier: float = 10) -> float:
	return (max_range - min_range + offset) * multiplier

func cal_max(max_range: float, offset: float = 5, multiplier: float = 10) -> float:
	return (max_range + offset) * multiplier

func _ready():
	set_physics_process(true)
	$min/range.shape.radius = cal_min(Data.Upgrades.MinRange, Data.Upgrades.MaxRange)
	$max/range.shape.radius = cal_max(Data.Upgrades.MaxRange)
	if get_parent() is Node2D:
		$min.scale = Vector2(1/get_parent().scale.x,1/get_parent().scale.y)
		$max.scale = Vector2(1/get_parent().scale.x,1/get_parent().scale.y)

func _on_max_area_entered(area):
	if area.get_parent().is_in_group("minions"):
		var pos = round_to_5s(area.get_parent().global_position)
		if !targets.has(pos):
			targets[pos] = 0
		targets[pos] += 1
		target.global_position = targets.find_key(targets.values().max())
		targeting = [target.position]
		#$Sprite2D.global_position = target.position
		
func round_to_5s(vec: Vector2) -> Vector2:
	return Vector2(round(vec.x / 10.0) * 10.0, round(vec.y / 10.0) * 10.0)

func _on_max_area_exited(_area): pass
func _on_min_area_entered(_area): pass
func _on_min_area_exited(_area): pass
