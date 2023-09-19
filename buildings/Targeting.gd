extends Node

@onready var Tower = $".."
var in_range = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Tower.Data["targetingRrange"]:
		return
	$Min/CollisionShape2D.shape.radius = Tower.Data["targetingRrange"][0]
	$Max/CollisionShape2D.shape.radius = Tower.Data["targetingRrange"][1]
	
	if !Tower.Data["targetCount"]:
		if Tower.Data["targeting"]:
			return
	if Tower.Data["targetCount"]:
		if Tower.Data["targeting"].size() == Tower.Data["targetCount"]:
			return
	for target in in_range:
		in_range.erase(target)
		if is_instance_valid(target):
			Tower.Data["targeting"].append(target)
			return

func _on_min_area_exited(area):
	add(area)

func _on_max_area_entered(area):
	if !area.get_parent().is_in_group("minions"):
		return
	add(area)
		
func _on_min_area_entered(area):
	del(area)

func _on_max_area_exited(area):
	del(area)

func add(area):
	if !area.get_parent().is_in_group("minions"):
		return
	if Tower.Data["targeting"].is_empty():
		Tower.Data["targeting"].append(area)
		return
	in_range.append(area)

func del(area):
	if !area.get_parent().is_in_group("minions"):
		return
	if area in Tower.Data["targeting"]:
		Tower.Data["targeting"].erase(area)
