extends Node2D

@export var Data = {
	"range" : [100.0, 300.0],
	"angle": [-90.0, 90.0],
	"max_target_count": 3,
}
var targets = {}
var targeting = []
var target = Area2D.new()
var minions_in_max_area = []

func _ready():
	$min/range.shape.radius = float(Data["range"][0])
	$max/range.shape.radius = float(Data["range"][1])
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
		$Sprite2D.global_position = target.position
		print(targets.values().max(),target.position)
		
func round_to_5s(vec: Vector2) -> Vector2:
	return Vector2(round(vec.x / 10.0) * 10.0, round(vec.y / 10.0) * 10.0)

func _on_max_area_exited(_area): pass
func _on_min_area_entered(_area): pass
func _on_min_area_exited(_area): pass
