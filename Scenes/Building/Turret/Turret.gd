extends Node2D

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
var markers = []
var rotation_coords = []

func _ready():
	set_process(true) # if you have processing logic
	set_physics_process(true) # if you have physics logic
	set_rotation_coords()
#	aspd.wait_time = 1/Data["aspd"][0]
#	cd.wait_time = Data["cooldown"][0]
	load_item_script("Targeting","Type","Fixed")
	add_projectiles_node()
	add_timers()
	$Targeting.property_list_changed.connect(_on_targeting_property_list_changed)


func _process(delta: float) -> void:
	$Icon.position = $Muzzle.position + $Muzzle.points[-$Sprite.frame]

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
		#instance.top_level = true
		var script = "res://Scenes/Projectiles/Type/Linear.gd"
		var rot = get_turret_rotation_to_face_target(self, $Targeting.targeting[0])
		var frame = rotation_to_frame(rot)
		$Sprite.frame = frame
		FileAccess.file_exists(script)
		if FileAccess.file_exists(script):
			instance.set_script(load(script))
			instance.target = $Targeting.targeting[0]
			instance.projectileSpeed = [600, 600]
			instance._ready()
		instance.global_position = $Muzzle.global_position + $Muzzle.points[-$Sprite.frame]/2
		$Projectiles.add_child(instance)

func set_rotation_coords():
	var sp:AnimatedSprite2D = get_node("Sprite")
	var path = sp.sprite_frames.resource_path.replace(".tres", ".tscn")
	var scene = load(path)
	var instance = scene.instantiate()
	instance.name = "Muzzle"
	#instance.visible = false
	add_child(instance)
	return

func rotation_to_frame(rot: float) -> int:
	rot += PI / 2
	while rot < 0:
		rot += 2 * PI
	rot = fmod(rot, 2 * PI)
	var frame = int(rot / (2 * PI) * 64)
	return frame

func correct_allign(frame):
	if frame >= 32:
		frame -=32
	frame +=32
	return frame

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
