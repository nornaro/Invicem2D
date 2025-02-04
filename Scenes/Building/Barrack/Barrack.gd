extends StaticBody2D

var minion = preload("res://Scenes/Minions/Minion/minion.tscn")

@export var Data = {
	"Properties": {
		"Power": "Normal", # Can put a barrack to overdrive for higher cost, it can disable, hurt or destroy barrack
		"Projectile": "FireBall",
		"Sabotage": "None", # Negative effect on attacker
		"Element": "Neutral", # Different element, different dmg multiplier
	},
	"Info": {},
	"Inventory": {},
	"Upgrades" : {
		"Speed": 1, # 1 # Movement speed
		"HP": 1, # 2 # Maximum health
		"Defense": 0, # 3 # Reduce dmg recieved by fix amount, or %
		"Size": 0, # 4 # Increase Size&HP or reduce Size&HP and hitbox with it, % or amount
		"Dummy": 0, # 5 # 2DO
		"Shield": 0, # 6 # n hit or %HP barrier
		"Regeneration": 0, # 7 # As time passes, constant % or amount HP regen, or % regained on hit, or increase Size&HP, or regain % HP at % HP if not executed
		"Movement": 0, # 8 # ground vs air
		"Stealth": 0, # 9 # pemanent, on hit, periodic
		"Evasion": 0, # 10 # everx n hits it blocks the next m, % chance to block
		"LootDrop": 0, # 11 # % chance to drop from n level
		"CCResist": 0, # 12 # Reduce the efficiency of all CC, at max lvl gain CC immun
		"CritResist": 0, # 13 # Reduce the efficiency of Crit, at max lvl gain Crit immun
		"LessBounty": 0, # 14 # Reduce the ammount of bounty the other player gets
		"SpeedBoost": 0, # 15 # If not eliminated in time, significantly increases speed for the finish
		"Siblings": 0, # 16 # Spawns multiple of the unit, but with less HP
		"Ankh": 0, # 17 # Revives at % of the HP once, or HP has to be recuced to 0 multiple times, or Splits into n pieces with portion of the HP m times
		"Efficiency": 0, # 18 # Energy efficiency of the Barrack
	},
}
@export var Modifier = {}

func _ready():
	var group = get_parent().name
	add_to_group(group)
	pass

func spawn():
	var spawn = get_tree().get_first_node_in_group("Spawn")
	var minions = get_tree().get_first_node_in_group("Minions")
	
	if is_in_group("temp"):
		return
	var instance = minion.instantiate()
	instance.position = Vector2(spawn.position.x,randi_range(-spawn.scale.y,spawn.scale.y))
	instance.name = str(instance.get_instance_id())
	instance.Data.merge(Data.Upgrades)
	instance.Data.merge(Data.Properties)
	minions.add_child(instance)

func _on_area_2d_area_entered(_area):
	pass
	
func _on_area_2d_area_exited(_area):
	pass
	
func _on_area_2d_input_event(_viewport, _event, _shape_idx):
	pass
	
func _on_area_2d_mouse_entered():
	pass
	
func _on_area_2d_mouse_exited():
	pass
