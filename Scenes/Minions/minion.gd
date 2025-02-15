extends RigidBody2D

@export var Data:Dictionary = {}
var regen:float = 0

@onready var Sprite:Node = $Sprite
@onready var hpBar:Node = $hpBar
@onready var shBar:Node = $shBar
@onready var sh:Node = $Shield
@onready var h2:Node = $Shield/Hit2
@onready var depleted:Node = $Shield/Depleted
@onready var area:Node = $MinionArea
var linear_velocity

func _ready() -> void:
	add_to_group("minions")
	#gravity_scale = 0
	Data["name"]= name
	Data.HP *= 1.0
	Data.HP = ceil(Data.HP * (1+Data.Size /10))
	Data["max_hp"] = Data.HP
	hpBar.max_value=Data.max_hp
	Data.Shield = int(Data.Shield * Data.max_hp / 10)
	Data["max_sh"] = Data.Shield
	shBar.max_value=Data.max_sh
	hpBar.value = Data.max_sh
	Data.Defense = ceil(Data.Defense * (1+Data.Size /10))
	Data.Speed += 5 - floor(Data.Size / 4)
	Data.Speed -= floor(Data.Size / 4)
	shBar.value = Data.max_sh
	linear_velocity = Vector2(-Data.Speed * 5, 0)
	var global:Dictionary = Global.Data.Minions
	var type:String = Data.Minion[0]
	var minion:String = Data.Minion[1]
	var sprite:String = global[type][minion].keys().pick_random()
	if global[type][minion][sprite].has_meta("scale"):
		Sprite.scale = Vector2(1,1) * global[type][minion][sprite].get_meta("scale")
	Sprite.speed_scale = 1+Data.Speed
	Sprite.sprite_frames = global[type][minion][sprite]
	sh.scale *= (1+Data.Size)/2.0
	Sprite.scale *= (1+Data.Size)/2.0
	hpBar.scale.x *= (1+Data.Size)/2.0
	shBar.scale.x *= (1+Data.Size)/2.0
	hpBar.position += Vector2(-Data.Size*3,-Data.Size*3)
	shBar.position += Vector2(-Data.Size*3,-Data.Size*3)
	area.scale *= (1+Data.Size)/2.0
	Sprite.play("Walking")
	depleted.connect("animation_finished",sh.hide)

###unprocess
func _physics_process(delta: float) -> void:
	position += linear_velocity
	z_index = int(position.y)
	if get_tree().get_node_count_in_group("true"):
		return
	shield(delta)
	correct_rotation(delta)
	regeneration(delta)
	notify_property_list_changed()

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
	var damage:int = calc_damage(data)
	if !damage:
		notify_property_list_changed()
		return
	Data.HP -= damage
	update_hpbar()
	if hpBar.value == 0:
		remove_from_group("minions")
		linear_velocity = Vector2.ZERO
		Sprite.play("Dying")
		Sprite.connect("animation_looped",queue_free)
		area.death()
		area.queue_free()
		return
	notify_property_list_changed()


func shield(delta: float) -> void:
	if shBar.value == 0:
		shBar.hide()
		sh.hide()
		return
	shBar.show()
	sh.show()
	if h2.modulate.a > 0.0:
		h2.modulate.a -= delta
#data.Damage*data.base_damage,data.Penetration,data.Crit,data.crit_multi
func calc_damage(data:Dictionary) -> int:
	var damage:int = data.Damage*data.base_damage
	var crit:int = 0
	if Data.has("CritResit"):
		crit = data.Crit - Data.CritResit
	if randi_range(0,100) < crit * data.crit_chance:
		damage *= 1 + ceil(crit / data.crit_multi)
	if Data.Shield > 0:
		Data.Shield = clamp(Data.Shield - damage, 0, Data.Shield)
		shBar.value = Data.Shield
		if shBar.value > 0:
			#h1.modulate.a = 1
			h2.modulate.a = 1
			h2.play("default")
		return clamp(damage - Data.Shield, 0, damage)
	depleted.play("default")	
	shBar.value = 0
	return data.Damage / max(1.0, 1.0 + Data.Defense - data.Penetration)

func update_hpbar() -> void:
	hpBar.value = Data.HP
	var new_color:Color = Color(1, pow(Data.HP / Data.max_hp, 2), pow(Data.HP / Data.max_hp, 2)/2, 0.75)
	hpBar.modulate = new_color
