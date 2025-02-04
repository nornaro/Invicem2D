extends RigidBody2D

@export var Data = {}
var regen = 0

func _ready():
	add_to_group("minions")
	gravity_scale = 0
	Data["max_hp"]=Data.HP
	$hpBar.max_value=Data.max_hp
	linear_velocity = Vector2(-Data.Speed*50,0)
	scale = Vector2(1,1) * (1 + Data.Size/10)

func _physics_process(delta):
	if get_tree().get_nodes_in_group("true").size()>0:
		return
	if rotation != 0:
		if rotation > 0+delta:
			rotation -= delta
		if rotation < 0-delta:
			rotation += delta
		if abs(rotation) < delta:
			rotation = 0
	regen += delta * Data.Regeneration
	if regen >= 1:
		regen -= 1
		Data.HP += 1
	notify_property_list_changed()	

	
func hurt(damage,pen):
	Data.HP -= calc_damage(damage,pen)
	if Data.HP <= 0:
		queue_free()
		return
	$hpBar.modulate = Color(1, pow(Data.HP / Data.max_hp, 2), 0, 0.75)
	$hpBar.value = Data.HP
	notify_property_list_changed()

func calc_damage(damage,pen):
	if Data.Shield > 0:
		Data.Shield = clamp(Data.Shield - damage, 0, Data.Shield)
		return clamp(damage - (Data.Shield - Data.Shield), 0, damage)
	return damage / max(1.0, 1.0 + Data.Defense - pen)
	
