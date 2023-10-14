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
var muzzle_positions: Array[Vector2] = []
var markers = []
var rotation_coords = {}

func _ready():
	set_process(true) # if you have processing logic
	set_physics_process(true) # if you have physics logic
#	aspd.wait_time = 1/Data["aspd"][0]
#	cd.wait_time = Data["cooldown"][0]
	load_item_script("Targeting","Type","Fixed")
	add_projectiles_node()
	add_timers()
	$Targeting.property_list_changed.connect(_on_targeting_property_list_changed)
	_create_muzzle_markers()
	_populate_rotation_coords()

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
	if !Data.has("muzzle"):
		return
	for i in Data["muzzle"].size():
		var scene = load("res://Scenes/Projectiles/Projectile.tscn")
		var instance = scene.instantiate()
		instance.name = str(instance.get_instance_id())
		get_node("MuzzleMarker"+str(i)).add_child(instance)
		
		var script = "res://Scenes/Projectiles/Type/Homing.gd"
		var rot = get_turret_rotation_to_face_target(self, $Targeting.targeting[0])
		FileAccess.file_exists(script)
		if FileAccess.file_exists(script):
			instance.set_script(load(script))
			instance.target = $Targeting.targeting[0]
			instance.projectileSpeed = [600, 600]
			instance._ready()
		var frame = rotation_to_frame(rot)
		$Sprite.frame = frame
		get_node("MuzzleMarker"+str(i)).position = get_muzzle_position_for_frame(frame)[i]
		#instance.global_position = global_position+get_muzzle_positions_for_frame(frame)[0]*scale.x

func _create_muzzle_markers():
	for i in Data["muzzle"].size():
		var marker = Marker2D.new()  # Use your custom Marker2D here
		marker.name = "MuzzleMarker"+str(i)
		marker.position = Data["muzzle"][i]
		marker.modulate = Color.MAGENTA
		marker.show()
		marker.gizmo_extents = 100
		add_child(marker)
		markers.append(marker)

		var sprite = Sprite2D.new()
		sprite.texture = load("res://icon.svg")
		sprite.scale = Vector2(0.05,0.05)
		marker.add_child(sprite)

func _populate_rotation_coords():
	var frame_count = Data["rotation_offset"][0]
	var offset = Vector2(Data["rotation_offset"][1], Data["rotation_offset"][2])
	var width_div_2 = Data["rotation_offset"][3]
	var radius = Data["rotation_offset"][4]

	for frame in range(frame_count):
		var angle = 2 * PI * frame / frame_count
		var rotated_offset = offset.rotated(angle)
		var oval_offset = Vector2(width_div_2 * cos(angle), radius * sin(angle))
		var position_for_frame = []
		for muzzle in Data["muzzle"]:
			position_for_frame.append(muzzle + rotated_offset + oval_offset)
		rotation_coords[frame] = position_for_frame

func get_muzzle_positions_for_frame(frame: int) -> Array:
	if !rotation_coords.has(frame):
		return []
	return rotation_coords[frame]

func rotation_to_frame(rot: float) -> int:
	rot += PI / 2
	while rot < 0:
		rot += 2 * PI
	rot = fmod(rot, 2 * PI)
	var frame = int(rot / (2 * PI) * 64)
	return frame
	
func get_muzzle_position_for_frame(frame: int) -> Array:
	frame = correct_allign(frame)
	var muzzle_positions = []
	var frame_count = Data["rotation_offset"][0]
	var offset = Vector2(Data["rotation_offset"][1], Data["rotation_offset"][2])
	var width_div_2 = Data["rotation_offset"][4]
	var radius = Data["rotation_offset"][3]

	var angle = 2 * PI * frame / frame_count

	for muzzle in Data["muzzle"]:
		var rotated_offset = offset.rotated(angle)
		var oval_offset = Vector2(width_div_2 * cos(angle), radius * sin(angle))
		muzzle_positions.append((muzzle + rotated_offset + oval_offset))
	return muzzle_positions

func correct_allign(frame):
	if frame >= 32:
		frame -=32
	frame +=32
	return frame

func get_muzzle_position(rad: float) -> Vector2:
	var x = Data["rotation_offset"][1] + Data["rotation_offset"][3]
	var y = Data["rotation_offset"][2] + Data["rotation_offset"][4]
	return global_position+Vector2(x * cos(rad), y * sin(rad))
#
#func get_muzzle_position(theta: float) -> Vector2:
#	var x = -15 + 90 * cos(theta)
#	var y = 5 + 70 * sin(theta)
#	return Vector2(x, y)

#func get_muzzle_position(rad: float) -> Vector2:
#	var x = Data["rotation_offset"][1] + Data["rotation_offset"][3]
#	var y = Data["rotation_offset"][2] + Data["rotation_offset"][4]
	
func get_precomputed_muzzle_position(index: int) -> Vector2:
	if index >= 0 and index < Data["rotation_offset"][0]:
		return muzzle_positions[index]
	else:
		print("Index out of range")
		return Vector2(0, 0)

func _on_CD_timeout():
	pass

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
