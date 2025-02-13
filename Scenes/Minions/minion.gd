extends RigidBody2D



@export var Data = {}
var regen = 0

@onready var Sprite = $Sprite
@onready var hpBar = $hpBar
@onready var shBar = $shBar
@onready var sh = $Shield
@onready var h2 = $Shield/Hit2
@onready var depleted = $Shield/Depleted

func _ready():
	add_to_group("minions")
	gravity_scale = 0
	Data["name"]= name
	Data.HP *= 100.0
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
	var global = Global.Data.Minions
	var type = Data.Minion[0]
	var minion = Data.Minion[1]
	var sprite = global[type][minion].keys().pick_random()
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
	$Area.scale *= (1+Data.Size)/2.0
	Sprite.play("Walking")
	depleted.connect("animation_finished",hide_shield)

func _physics_process(delta):
	z_index = int(position.y)
	if get_tree().get_node_count_in_group("true"):
		return
	shield(delta)
	correct_rotation(delta)
	regeneration(delta)
	notify_property_list_changed()

func regeneration(delta) -> void:
	regen += delta
	if regen >= 1:
		regen -= 1
		Data.HP += Data.max_hp/100 * Data.Regeneration
		update_hpbar()

func correct_rotation(delta) -> void:
	if rotation != 0:
		if rotation > 0+delta:
			rotation -= delta
		if rotation < 0-delta:
			rotation += delta
		if abs(rotation) < delta:
			rotation = 0
	
func hurt(data):
	var damage = calc_damage(data)
	if !damage:
		notify_property_list_changed()
		return
	Data.HP -= damage
	update_hpbar()
	if hpBar.value == 0:
		linear_velocity = Vector2.ZERO
		$Area.queue_free()
		Sprite.play("Dying")
		Sprite.connect("animation_looped",die)
		return
	notify_property_list_changed()

func die():
	queue_free()

func shield(delta) -> void:
	if shBar.value == 0:
		shBar.hide()
		sh.hide()
		return
	shBar.show()
	sh.show()
	if h2.modulate.a > 0.0:
		h2.modulate.a -= delta
#data.Damage*data.base_damage,data.Penetration,data.Crit,data.crit_multi
func calc_damage(data):
	var damage = data.Damage*data.base_damage
	var crit = 0
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

func hide_shield():
	sh.hide()

func update_hpbar():
	hpBar.value = Data.HP
	var new_color = Color(1, pow(Data.HP / Data.max_hp, 2), pow(Data.HP / Data.max_hp, 2)/2, 0.75)
	hpBar.modulate = new_color
