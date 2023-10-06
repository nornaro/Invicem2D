extends StaticBody2D

@export var Data = {
	"aspd":[2,2],
}
var slots = {
	"Targeting": null,
	"Modifier1": null,
	"Modifier2": null,
}
var max_slots = 3
var timer_ASPD = Timer.new()
var timer_CD = Timer.new()
var targeting = []

func _ready():
	set_process(true) # if you have processing logic
	set_physics_process(true) # if you have physics logic
#	aspd.wait_time = 1/Data["aspd"][0]
#	cd.wait_time = Data["cooldown"][0]
	load_item_script("Targeting","Type","Fixed")
	add_projectiles_node()
	add_timers()
	$Targeting.property_list_changed.connect(_on_targeting_property_list_changed)

func add_timers():
	timer_ASPD.name = "ASPD"
	timer_ASPD.wait_time = 0.2  # For example, 1 second
	timer_ASPD.one_shot = false
	timer_ASPD.connect("timeout", _on_ASPD_timeout)
	add_child(timer_ASPD)

	# Setup the CD timer (one-shot)
	timer_CD.name = "CD"
	timer_CD.wait_time = 3.0  # For example, 3 seconds
	timer_CD.one_shot = true
	timer_CD.connect("timeout", _on_CD_timeout)
	add_child(timer_CD)

	# Start the timers
#	timer_ASPD.start()
#	timer_CD.start()

func _on_ASPD_timeout():
	if $Targeting.targeting.is_empty():
		timer_ASPD.stop()
		return
	if !$Targeting.targeting[0]:
		timer_ASPD.stop()
		return
	var scene = load("res://Scenes/Projectiles/Projectile.tscn")
	var instance = scene.instantiate()
	instance.name = str(instance.get_instance_id())
	get_node("Projectiles").add_child(instance)
	
	var script = "res://Scenes/Projectiles/Type/Homing.gd"
	var rot = get_turret_rotation_to_face_target(self, $Targeting.targeting[0])
	FileAccess.file_exists(script)
	if FileAccess.file_exists(script):
		instance.set_script(load(script))
		instance.global_position = global_position+get_muzzle_position(rot)*scale.x
		instance.target = $Targeting.targeting[0]
		instance.projectileSpeed = [600, 600]
		instance._ready()
	$Sprite.frame = rotation_to_frame(rot)

func rotation_to_frame(rot: float) -> int:
	# Ensure the rotation is between 0 and 2*PI
	rot += PI / 2
	while rot < 0:
		rot += 2 * PI
	rot = fmod(rot, 2 * PI)

	# Convert the rotation to a frame index
	var frame = int(rot / (2 * PI) * 64)
	return frame

func get_muzzle_position(theta: float) -> Vector2:
	var h = -15.5
	var k = 0
	var a = 90
	var b = 70

	var x = h + a * cos(theta)
	var y = k + b * sin(theta)

	return Vector2(x, y)

func _on_CD_timeout():
	print("CD timer triggered!")

func add_projectiles_node():
	var projectiles = Node.new()
	projectiles.name = "Projectiles"
	add_child(projectiles)
	
func add_item_to_slot(item, slot_index):
	if slot_index < max_slots and slot_index >= 0:
		slots[slot_index] = item

func get_item_from_slot(slot_index):
	if slot_index > max_slots:
		return null
	if slot_index < 0:
		return null
	return slots[slot_index]

func load_item_script(slot,modify,item):
	var scene = load("res://Scenes/"+slot+"/"+slot+".tscn")
	var instance = scene.instantiate()
	slots[slot] = instance
#	instance.name = str(instance.get_instance_id())
	add_child(instance)
	var script = "res://Scenes/"+slot+"/"+modify+"/"+item+".gd"
	FileAccess.file_exists(script)
	if FileAccess.file_exists(script):
		instance.set_script(load(script))
		instance._ready()
		Data.merge(instance.Data)

func _on_targeting_property_list_changed():
	timer_ASPD.start()

func get_turret_rotation_to_face_target(turret: Node2D, target: Node2D) -> float:
	var dir = target.global_position - turret.global_position
	return atan2(dir.y, dir.x)








"""
func _process(delta):
	print("current_targets: ",current_targets)
	detect_targets()

func detect_targets():
	_filter_valid_targets()
	_add_potential_targets()
	_orient_towards_first_target()

func _filter_valid_targets():
	var valid_targets = []
	for target in current_targets:
		if not target:
			continue
		if not is_target_in_range(target):
			continue
		if not is_target_in_angle(target):
			continue
		valid_targets.append(target)
	current_targets = valid_targets

func _add_potential_targets():
	if current_targets.size() >= max_target_count:
		return

	var space_state = get_world_2d().direct_space_state
	
	var query_parameters = PhysicsPointQueryParameters2D.new()
	query_parameters.position = global_position
	query_parameters.exclude = [self]
	query_parameters.collision_mask = 1  # Adjust this based on your game's layer setup for potential targets

	var potential_targets = space_state.intersect_point(query_parameters)
	for pt in potential_targets:
		if current_targets.size() >= max_target_count:
			return
		var target = pt.collider
		if target in current_targets:
			continue
		if not is_target_in_range(target):
			continue
		if not is_target_in_angle(target):
			continue
		current_targets.append(target)

func _orient_towards_first_target():
	if current_targets.is_empty():
		return
	var dir = current_targets[0].global_position - global_position
	rotation = dir.angle()

func is_target_in_range(target):
	var distance = target.global_position.distance_to(global_position)
	return distance >= range[0] and distance <= range[1]

func is_target_in_angle(target):
	var dir = target.global_position - global_position
	var angle_to_target = rad_to_deg(dir.angle_to(Vector2.RIGHT))
	var turret_rotation_deg = rad_to_deg(rotation)
	return angle_to_target >= turret_rotation_deg + angle[0] and angle_to_target <= turret_rotation_deg + angle[1]

func on_target_died(target):
	if target in current_targets:
		current_targets.erase(target)
"""





