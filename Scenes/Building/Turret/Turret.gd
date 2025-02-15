extends Node2D

@onready var targeting_scene: PackedScene = preload("res://Scenes/Projectiles/Targeting.tscn")
@onready var projectiles_scene: PackedScene = preload("res://Scenes/Projectiles/Projectiles.tscn")
@onready var projectile_scene: PackedScene = preload("res://Scenes/Projectiles/Projectile.tscn")

var aspd_counter: int = 0
var is_targeting: bool = false

@export var Data: Dictionary = {
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

var max_slots:int = 4
var timer_ASPD:Timer = Timer.new()
var timer_CD:Timer = Timer.new()
var targeting: Array = []
var markers: Array = []
var rotation_coords: Array = []

func _ready() -> void:
	set_physics_process(true)
	set_rotation_coords()
	add_child(targeting_scene.instantiate())
	$"Targeting/min/range".shape = CircleShape2D.new()
	$"Targeting/max/range".shape = CircleShape2D.new()
	add_child(projectiles_scene.instantiate())
	var aspd_timer:Timer = get_tree().get_first_node_in_group("ASPD")
	aspd_timer.connect("timeout",_on_ASPD_timeout)
	#add_timers()
	#$Targeting.property_list_changed.connect(_on_targeting_property_list_changed)

#func add_timers() -> void:
	#timer_ASPD.name = "ASPD"
	#timer_ASPD.wait_time = 1/sqrt(Data.Upgrades.AttackSpeed)  # For example, 1 second
	#timer_ASPD.one_shot = false
	#timer_ASPD.connect("timeout", _on_ASPD_timeout)
	#add_child(timer_ASPD)
#
	## Setup the CD timer (one-shot)
	#timer_CD.name = "CD"
	#timer_CD.wait_time = 3.0  # For example, 3 seconds
	#timer_CD.one_shot = true
	#timer_CD.connect("timeout", _on_CD_timeout)
	#add_child(timer_CD)

func _on_ASPD_timeout() -> void:
	if !is_targeting:
		return
	if aspd_counter == (17-Data.Upgrades.AttackSpeed):
		aspd_counter = 0
		shoot()
		return
	aspd_counter += 1
	shoot()
	
func shoot() -> void:
	#if get_node_or_null("Muzzle"):
		#$Icon.position = $Muzzle.position + $Muzzle.points[-$Sprite.frame]
	#var _timer:float = float(1.0/Data.Upgrades.AttackSpeed)
	#timer_ASPD.wait_time = timer
	if !Data.Properties.has("Trajectory"):
		return
	if $Targeting.targeting.is_empty():
		return
	if !Data.has("muzzle"):
		return
	var multi: Array = calculate_multishot()
	var spread_range: int = Data.spreadbase-Data.Upgrades.Spread
	spread_range /= 2
	var spread: Vector2 = 5 * Vector2(
		randf_range(-spread_range,spread_range),
		randf_range(-spread_range,spread_range)
	)
	var target: Node2D = $Targeting.targeting[0]
	var rot: float = get_turret_rotation_to_face_target(self, target)
	var frame:int = rotation_to_frame(rot)
	$Sprite.frame = frame
	for i: int in range(Data.muzzle.size() + multi[0]):
		if !target:
			return
		spawn_projectile(multi[0],multi[1],spread,target)
		await get_tree().create_timer(0.01).timeout
		
func calculate_multishot() -> Array:
	var count: float = 1.0
	var damage: float = 100.0
	var m: Array = [1,7,13]
	for i: int in range(Data.Upgrades.Multishot):
		if m.has(i):
			damage /=2
			count += 1
			continue
		damage += 5
	return [count,damage/100]

func spawn_projectile(count:int,damage:int,spread:Vector2,target:Node) -> void:
		var instance:Node = projectile_scene.instantiate()
		instance.name = str(instance.get_instance_id())
		var script: String = "res://Scenes/Projectiles/Trajectory/" + Data.Properties.Trajectory + ".gd"
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

func set_rotation_coords() -> void:
	var sp:AnimatedSprite2D = get_node("Sprite")
	var scene = Global.RL.load(sp.sprite_frames.resource_path.replace(".tres", ".tscn"))
	var instance:Line2D = scene.instantiate()
	instance.name = "Muzzle"
	for point in instance.points:
		point += Vector2(-25,-50)
	#instance.hide()
	add_child(instance)
	return

func set_targeting() -> void:
	var script = "res://Scenes/Projectiles/Targeting/"+Data.Properties.Targeting+".gd"
	Global.RL.file_exists(script)
	if Global.RL.file_exists(script):
		$Targeting.set_script(Global.RL.load(script))
		$Targeting._ready()
	is_targeting = true

func rotation_to_frame(rot: float) -> int:
	rot += PI / 2
	while rot < 0:
		rot += 2 * PI
	rot = fmod(rot, 2 * PI)
	var frame = int(rot / (2 * PI) * 64)
	return frame

func correct_allign(frame: int) -> int:
	if frame >= 32:
		frame -=32
	frame +=32
	return frame

func _on_CD_timeout() -> void:
	pass

#func add_item_to_slot(item, slot_index):
	#if slot_index < max_slots and slot_index >= 0:
		#Data[slot_index] = item

func get_item_from_slot(slot_index: int) -> Dictionary:
	if slot_index > max_slots:
		return {}
	if slot_index < 0:
		return {}
	return Data[slot_index]

#func load_item_script(slot,modify,item):
	#var scene = Global.RL.load("res://Scenes/"+slot+"/"+slot+".tscn")
	#var instance:Node = scene.instantiate()
	#Data[slot] = instance
##	instance.name = str(instance.get_instance_id())
	#add_child(instance)
	#var script = "res://Scenes/"+slot+"/"+modify+"/"+item+".gd"
	#Global.RL.file_exists(script)
	#if Global.RL.file_exists(script):
		#instance.set_script(Global.RL.load(script))
		#instance._ready()
		#Data.merge(instance.Data)

#func _on_targeting_property_list_changed() -> void:
	#timer_ASPD.start()

func get_turret_rotation_to_face_target(turret: Node2D, target: Node2D) -> float:
	var dir = target.global_position - turret.global_position
	return atan2(dir.y, dir.x)
