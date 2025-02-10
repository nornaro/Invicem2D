extends Node2D

@onready var targeting_scene = preload("res://Scenes/Projectiles/Targeting.tscn")
@onready var projectiles_scene = preload("res://Scenes/Projectiles/Projectiles.tscn")
@onready var projectile_scene = preload("res://Scenes/Projectiles/Projectile.tscn")



@export var Data = {
	"muzzle": [Vector2.ZERO],
	"max_target_count": 3,
	"spreadbase": 15,
	"Skin": "",
	"Properties": {
		"Power": "Normal",
		"Targeting": "Fixed",
		"Trajectory": "Piercing",
		"Element": "Normal",
	},
	"Info": {},
	"Equip": {
		"Projectile": "Basic FireBall Projectile Module",
		"Frame": "Basic Support Frame Module",
		"Core": "Basic Drained Core Module",
		"Efficiency": "Basic Low Efficiency Module",
	},
	"Inventory": {},
	"Upgrades":{ ## some are ammo properties
		#Speed					#DMG->Ammo?			#Range			#Etc:AoE
		"AttackSpeed": 1, 		"Damage": 1, 		"MinRange": 1,	"Multishot": 1,
		"ProjectileSpeed": 1, 	"Penetration": 1, 	"MaxRange": 1,	"Flak": 0,
		"TargetingSpeed": 1, 	"Crit": 0, 			"Spread": 0,	"Splah": 0,
	},
	#"Upgrades":{í
		#"Speed": Vector3(1,1,1), # 1 # AttackSpeed/ProjectileSpeed/TargetingSpeed
		#"Damage": Vector3(1,1,1), # 3 # Damage/Penetration/Crit
		#"AoE": Vector3(1,1,1), # 1 # Multishot/Flak/Splash		
		#"Range": Vector3(1,1,1), # 9 # Min/Max/Spread
		#"Efficiency": 1, # 1 #
	#},
}

var max_slots = 4
var timer_ASPD = Timer.new()
var timer_CD = Timer.new()
var targeting = []
var markers = []
var rotation_coords = []

func _ready():
	set_process(true) # if you have processing logic
	set_physics_process(true) # if you have physics logic
	set_rotation_coords()
	add_child(targeting_scene.instantiate())
	$"Targeting/min/range".shape = CircleShape2D.new()
	$"Targeting/max/range".shape = CircleShape2D.new()
	add_child(projectiles_scene.instantiate())
	add_timers()
	$Targeting.property_list_changed.connect(_on_targeting_property_list_changed)


func _process(_delta: float) -> void:
	if get_node_or_null("Muzzle"):
		$Icon.position = $Muzzle.position + $Muzzle.points[-$Sprite.frame]

func add_timers():
	timer_ASPD.name = "ASPD"
	timer_ASPD.wait_time = 1/Data.Upgrades.AttackSpeed  # For example, 1 second
	timer_ASPD.one_shot = false
	timer_ASPD.connect("timeout", _on_ASPD_timeout)
	add_child(timer_ASPD)

	# Setup the CD timer (one-shot)
	timer_CD.name = "CD"
	timer_CD.wait_time = 3.0  # For example, 3 seconds
	timer_CD.one_shot = true
	timer_CD.connect("timeout", _on_CD_timeout)
	add_child(timer_CD)

func _on_ASPD_timeout():
	var timer = float(1.0/Data.Upgrades.AttackSpeed)
	timer_ASPD.wait_time = timer
	if !Data.Properties.has("Trajectory"):
		return
	if $Targeting.targeting.is_empty():
		#timer_ASPD.stop()
		return
	if !$Targeting.targeting[0]:
		#timer_ASPD.stop()
		return
	if !Data.has("muzzle"):
		return
	var multi = calculate_multishot()
	var spread_range = Data.spreadbase-Data.Upgrades.Spread
	spread_range /= 2
	var spread = 5 * Vector2(
		randf_range(-spread_range,spread_range),
		randf_range(-spread_range,spread_range)
	)
	var target = $Targeting.targeting[0]
	var rot = get_turret_rotation_to_face_target(self, target)
	var frame = rotation_to_frame(rot)
	$Sprite.frame = frame
	for i in range(Data.muzzle.size() + multi[0]):
		spawn_projectile(multi[0],multi[1],spread,target)
		await get_tree().create_timer(0.001).timeout
		
func calculate_multishot() -> Array:
	var count = 1.0
	var damage = 100.0
	var m = [1,5,9,13]
	for i in range(Data.Upgrades.Multishot):
		if m.has(i):
			damage /=2
			count += 1
			continue
		damage += 5
	return [count,damage/100]

func spawn_projectile(count,damage,spread,target) -> void:
		var instance = projectile_scene.instantiate()
		instance.name = str(instance.get_instance_id())
		var script = "res://Scenes/Projectiles/Trajectory/" + Data.Properties.Trajectory + ".gd"
		if Global.RL.file_exists(script):
			instance.set_script(Global.RL.load(script))
			instance.target = target
			instance.Data["Spawn"] = Data.Upgrades
			instance.Data.merge(Data.Properties)
			instance.Data.merge(Data.Upgrades)
			instance.Data.Spread = spread
			instance.Data.Damage *= damage
			instance.Data["Size"] = count
			instance._ready()
		instance.global_position = $Icon.global_position# + $Muzzle.points[-$Sprite.frame]/2
		$Projectiles.add_child(instance)
	

func set_rotation_coords():
	var sp:AnimatedSprite2D = get_node("Sprite")
	var scene = Global.RL.load(sp.sprite_frames.resource_path.replace(".tres", ".tscn"))
	var instance:Line2D = scene.instantiate()
	instance.name = "Muzzle"
	for point in instance.points:
		point += Vector2(-25,-50)
	#instance.hide()
	add_child(instance)
	return


func set_targeting():
	var script = "res://Scenes/Projectiles/Targeting/"+Data.Properties.Targeting+".gd"
	Global.RL.file_exists(script)
	if Global.RL.file_exists(script):
		$Targeting.set_script(Global.RL.load(script))
		$Targeting._ready()

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

#func add_item_to_slot(item, slot_index):
	#if slot_index < max_slots and slot_index >= 0:
		#Data[slot_index] = item

func get_item_from_slot(slot_index):
	if slot_index > max_slots:
		return null
	if slot_index < 0:
		return null
	return Data[slot_index]

#func load_item_script(slot,modify,item):
	#var scene = Global.RL.load("res://Scenes/"+slot+"/"+slot+".tscn")
	#var instance = scene.instantiate()
	#Data[slot] = instance
##	instance.name = str(instance.get_instance_id())
	#add_child(instance)
	#var script = "res://Scenes/"+slot+"/"+modify+"/"+item+".gd"
	#Global.RL.file_exists(script)
	#if Global.RL.file_exists(script):
		#instance.set_script(Global.RL.load(script))
		#instance._ready()
		#Data.merge(instance.Data)

func _on_targeting_property_list_changed():
	timer_ASPD.start()

func get_turret_rotation_to_face_target(turret: Node2D, target: Node2D) -> float:
	var dir = target.global_position - turret.global_position
	return atan2(dir.y, dir.x)
