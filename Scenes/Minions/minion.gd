extends Node2D

@export var Data:Dictionary = {}
var regen:float = 0

@onready var Sprite:Node = $Sprite
@onready var hpBar:Node = $hpBar
@onready var shBar:Node = $shBar
@onready var sh:Node = $Shield
@onready var h0:Node = $Shield/s0
@onready var h2:Node = $Shield/Hit2
@onready var depleted:Node = $Shield/Depleted
@onready var area:Node = $MinionArea
var linear_velocity: Vector2
var dead:bool = false


func _ready() -> void:
	shBar.hide()
	sh.hide()
	if !area.has_meta("owner"):
		add_to_group("minions")
		#gravity_scale = 0
		Data["name"]= name
		Data.HP *= 100
		Data.HP = ceil(Data.HP * (1+Data.Size /10))
		Data["max_hp"] = Data.HP
		hpBar.max_value=Data.max_hp
		Data.Shield = int(Data.Shield * Data.max_hp / 2)
		Data["max_sh"] = Data.Shield
		shBar.max_value=Data.max_sh
		hpBar.value = Data.max_sh
		Data.Defense = ceil(Data.Defense * (1+Data.Size /10))
		Data.Speed += 5 - floor(Data.Size / 4)
		Data.Speed -= floor(Data.Size / 4)
		shBar.value = Data.max_sh
	linear_velocity = clamp(Vector2(-Data.Speed/5, 0),Vector2(-1,0),Vector2(-Data.Speed/5, 0))
	var global:Dictionary = Global.Data.Minions
	var type:String = Data.Minion[0]
	var minion:String = Data.Minion[1]
	var sprite:String = global[type][minion].keys().pick_random()
	#var area_scale = Sprite.sprite_frames.get_frame_texture("Idle",0).set_size()
	#if global[type][minion][sprite].has_meta("scale"):
		#Sprite.scale = Vector2(1,1) * global[type][minion][sprite].get_meta("scale")
	Sprite.speed_scale = 1+Data.Speed
	Sprite.sprite_frames = global[type][minion][sprite]
	#sh.scale *= (1+Data.Size)/2.0
	scale *= 10+Data.Size
	#hpBar.scale.y = Data.Size/15
	#shBar.scale.y = Data.Size
	hpBar.position.y -= Data.Size/10
	shBar.position.y -= Data.Size/10
	#print(Sprite.sprite_frames.get_frame_texture("Idle",0).get_size())
	#$MinionArea/CollisionShape2D.shape = CapsuleShape2D.new()
	#$MinionArea/CollisionShape2D.shape.radius = 4 * (1+Data.Size)
	#$MinionArea/CollisionShape2D.shape.height = 20 * (1+Data.Size)
	Sprite.play("Walking")
	depleted.connect("animation_finished",sh.hide)
	if shBar.value > 0:
		var mod:float = clamp(Data.Shield/10000.0,0.05,1)
		h0.self_modulate.a = mod
		shBar.show()
		sh.show()

###unprocess
func _physics_process(delta: float) -> void:
	position += linear_velocity * 60 / Engine.physics_ticks_per_second
	z_index = int(position.y)
	if get_tree().get_node_count_in_group("true"):
		return
	shield(delta)
	correct_rotation(delta)
	regeneration(delta)
	#notify_property_list_changed()

func regeneration(delta: float) -> void:
	regen += delta
	if regen >= 1:
		regen -= 1
		Data.HP += Data.max_hp/100 * Data.Regeneration
		update_hpbar()

func correct_rotation(delta: float) -> void:
	if rotation != 0:
		if rotation > 0+delta:
			rotation -= delta
		if rotation < 0-delta:
			rotation += delta
		if abs(rotation) < delta:
			rotation = 0
	
func hurt(data:Dictionary) -> void:
	if dead:
		return
	var damage:int = calc_damage(data)
	if !damage:
		#notify_property_list_changed()
		return
	Data.HP -= damage
	update_hpbar()
	#print(Data.HP,",",Data.max_sh,",",damage,",",data.base_damage)
	if hpBar.value == 0:
		dead = true
		remove_from_group("minions")
		linear_velocity = Vector2.ZERO
		Sprite.connect("animation_looped",queue_free)
		Sprite.play("Dying")
		await get_tree().create_timer(10).timeout
		area.death()
		area.queue_free()
		return
	#notify_property_list_changed()


func shield(delta: float) -> void:
	if shBar.value == 0:
		return
	if h2.self_modulate.a > 0.0:
		h2.self_modulate.a -= delta

#data.Damage*data.base_damage,data.Penetration,data.Crit,data.crit_multi
func calc_damage(data: Dictionary) -> int:
	# Step 1: Calculate Crit Multiplier and Apply to Damage
	var damage: int = data.Damage * data.base_damage
	var crit: int = data.Crit
	
	# If CritResist is available in the current script data (Data), apply it
	if Data.has("CritResist"):
		crit -= Data.CritResist  # Adjust crit based on CritResist from the current script data
	
	# Calculate critical hit chance and apply crit multiplier if it's a critical hit
	var crit_chance:bool = randi_range(0, 100) < crit * data.crit_chance
	if crit_chance:
		# Apply critical damage multiplier (randomized within a given range)
		damage *= 1 + randi_range(1, ceil(crit / data.crit_multi))

	# Step 2: Reduce Damage by Remaining Shield (Keep Above 0)
	if Data.Shield > 0:
		h2.self_modulate.a = 1
		var damage_after_shield:int = damage - Data.Shield
		if damage_after_shield < 0:
			Data.Shield = clamp(Data.Shield - damage, 0, Data.Shield)  # Reduce shield accordingly
			shBar.value = Data.Shield  # Update shield bar value
			return 0  # All damage absorbed by shield, return 0 damage
		
		# If shield isn't enough, reduce shield and keep the remaining damage
		Data.Shield = clamp(Data.Shield - damage, 0, Data.Shield)
		if !Data.Shield:
			shield_depleted()
		var mod:float = clamp(Data.Shield/10000.0,0.05,1)
		h0.self_modulate.a = mod
		shBar.value = Data.Shield  # Update shield bar value
		damage = damage_after_shield  # Remaining damage after shield absorption
	
	# Step 3: Reduce Remaining Damage Based on Defense and Penetration (Keep Above 0)
	var defense:int = clamp(Data.Defense - data.Penetration, 0, 20)
	var remaining_damage: float = float(damage)
	if data.has("armor"):
		if !data.armor[0]:
			remaining_damage = damage * (1 - data.armor[1] * defense / 100)
		if data.armor[0]:
			remaining_damage = damage - defense * data.armor[1]
	return max(int(remaining_damage), 0)


func update_hpbar() -> void:
	hpBar.value = Data.HP
	var new_color:Color = Color(1, pow(Data.HP*100 / Data.max_hp*100, 2), pow(Data.HP*100 / Data.max_hp*100, 2)/2, 0.75)
	hpBar.modulate = new_color

func shield_depleted() -> void:
	#depleted.show()
	#depleted.play("default")
	#await get_tree().create_timer(0.5).timeout 
	shBar.hide()
	sh.hide()
