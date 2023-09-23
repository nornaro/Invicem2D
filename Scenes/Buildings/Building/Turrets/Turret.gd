extends Node2D

@onready var Tower = $".."

var in_range = []
var targeting = []

func _ready():
	$Min/CollisionShape2D.shape.radius = Tower.Data["targetingRrange"][0]
	$Max/CollisionShape2D.shape.radius = Tower.Data["targetingRrange"][1]

func _process(_delta):
	if targeting.size() < Tower.Data["aoe"][0]:
		for target in in_range:
			in_range.erase(target)
			if is_instance_valid(target):
				targeting.append(target)

func _on_min_area_exited(area):
	add(area)

func _on_max_area_entered(area):
	if !area.get_parent().is_in_group("minions"):
		return
	in_range.append(area)
	add(area)
		
func _on_min_area_entered(area):
	del(area)

func _on_max_area_exited(area):
	del(area)

func add(area):
	if !area.get_parent().is_in_group("minions"):
		return
	if targeting.size() < Tower.Data["aoe"][0]:
		in_range.erase(area)
		targeting.append(area)

func del(area):
	if !area.get_parent().is_in_group("minions"):
		return
	if area in targeting:
		targeting.erase(area)
	
	
