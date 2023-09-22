extends Node2D

@export var targetingRrange = [10, 600] # min, max
@export var aoe = [5, 1] # targets, splash
@export var aspd = [1, 1] # min, max
@export var dmg = [1, 1] # min, max
@export var tdelay = [0, 0] # targeting delay, first target, retarget
@export var cooldown = [0, 0] # time aFter it has to stopm how long
@export var pspeed = [500, 500] # min, max
var in_range = []
var targeting = []

func _ready():
	$Min/CollisionShape2D.shape.radius = targetingRrange[0]
	$Max/CollisionShape2D.shape.radius = targetingRrange[1]

func _process(delta):
	if targeting.size() < aoe[0]:
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
	if targeting.size() < aoe[0]:
		in_range.erase(area)
		targeting.append(area)

func del(area):
	if !area.get_parent().is_in_group("minions"):
		return
	if area in targeting:
		targeting.erase(area)
	
	
