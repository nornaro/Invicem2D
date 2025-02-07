extends RigidBody2D

@export var Data = {}
var regen = 0

@onready var Sprite = $Sprite
@onready var hpBar = $hpBar
@onready var shBar = $shBar
@onready var sh = $Shield

func _ready():
	add_to_group("minions")
	gravity_scale = 0
	
	if !Data.has("max_hp"):
		Data.HP *= Data.HP * 100.0
		Data["max_hp"] = Data.HP
		Data.Shield = int(Data.Shield * Data.max_hp / 10)
		Data["max_sh"] = Data.Shield
		hpBar.max_value=Data.max_hp
		shBar.max_value=Data.max_sh
		hpBar.value = Data.max_hp
		shBar.value = Data.max_sh
	linear_velocity = Vector2(-Data.Speed-5,0)*10
	var global = Global.Data.Minions
	var type = Data.Minion[0]
	var minion = Data.Minion[1]
	var sprite = global[type][minion].keys().pick_random()
	if global[type][minion][sprite].has_meta("scale"):
		Sprite.scale = Vector2(1,1) * global[type][minion][sprite].get_meta("scale")
	Sprite.sprite_frames = global[type][minion][sprite]
	Sprite.play("Walking")
	Sprite.scale *= Data.Size
	$Area.scale *= Data.Size

func _physics_process(delta):
	z_index = int(position.y)
	#scale *= Data.Size # force scale
	if get_tree().get_node_count_in_group("true"):
		return
	shield(delta)
	correct_rotation(delta)
	regeneration(delta)
	notify_property_list_changed()

func regeneration(delta) -> void:
	regen += delta * Data.Regeneration
	if regen >= 1:
		regen -= 1
		Data.HP += 1
		print("+1")

func correct_rotation(delta) -> void:
	if rotation != 0:
		if rotation > 0+delta:
			rotation -= delta
		if rotation < 0-delta:
			rotation += delta
		if abs(rotation) < delta:
			rotation = 0
	
func hurt(damage,pen):
	damage = calc_damage(damage,pen)
	if !damage:
		notify_property_list_changed()
		return
	Data.HP -= damage
	hpBar.value = Data.HP
	if hpBar.value == 0:
		$Area.queue_free()
		Sprite.play("Dying")
		Sprite.connect("animation_looped",queue_free)
		return
	var new_color = Color(1, pow(Data.HP / Data.max_hp, 2), 0, 0.75)
	hpBar.modulate = new_color
	notify_property_list_changed()

func shield(delta) -> void:
	if shBar.value == 0:
		shBar.hide()
		sh.hide()
		return
	shBar.show()
	sh.show()
	if sh.modulate.a > 0.2:
		sh.modulate.a -= delta * 10

func calc_damage(damage,pen):
	if Data.Shield > 0:
		Data.Shield = clamp(Data.Shield - damage, 0, Data.Shield)
		shBar.value = Data.Shield
		if shBar.value > 0:
			sh.modulate.a = 1
		return clamp(damage - Data.Shield, 0, damage)
	shBar.value = 0
	return damage / max(1.0, 1.0 + Data.Defense - pen)
