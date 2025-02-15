extends StaticBody2D

@onready var minion:PackedScene = preload("res://Scenes/Minions/minion.tscn")


@export var Data: Dictionary = {
	"Properties": {
		"Power": "Normal", # Can put a barrack to overdrive for higher cost, it can disable, hurt or destroy barrack
		"Projectile": "FireBall",
		"Sabotage": "None", # Negative effect on attacker
		"Element": "Neutral", # Different element, different dmg multiplier
	},
	"Info": {},
	"Equip": {
		"Minion": ["Chibi", "Select", "Minion", "Module"],
		"Dummy1": ["Basic", "", "", "Module"],
		"Core": ["Basic", "Drained", "Core", "Module"],
		"Efficiency": ["Basic", "Low", "Efficiency", "Module"],
	},
	"Inventory": {},
	"Upgrades" : {
		"Speed": 1, # 1 # Movement speed
		"HP": 1, # 2 # Maximum health
		"Defense": 0, # 3 # Reduce dmg recieved by fix amount, or %
		"Size": 1, # 4 # Increase Size&HP or reduce Size&HP and hitbox with it, % or amount
		"Shield": 0, # 5 # n hit or %HP barrier
		"Regeneration": 0, # 6 # As time passes, constant % or amount HP regen, or % regained on hit, or increase Size&HP, or regain % HP at % HP if not executed
		"Movement": 0, # 7 # ground vs aííir
		"Efficiency": 0, # 8 # Energy efficiency of the Barrack
		"SpeedBoost": 0, # 9 # If not eliminated in time, significantly increases speed for the finish
		
		##"Evasion": 0, # 10 # everx n hits it blocks the next m, % chance to block
		##"LootDrop": 0, # 5 # 5% less chance to drop item, or -1 item level -> Combine 16 to gain Lootless
		##"Stealth": 0, # 9 # onhit or periodic -> Combine 16 to gain pemanent
		##"CCResist": 0, # 12 # Reduce the efficiency or chance of all CC -> Combine 16 to gain immun
		##"CritResist": 0, # 13 # Reduce the efficiency or frequency of Crit, at max lvl gain immun
		##"LessBounty": 0, # 14 # Reduce the ammount of bounty the other player gets -> Combine 16 to gain Lootless
		##"Divide": 0, # 16 # Multiplying after time, Mass Production Spawns multiple of the unit, but with less HP, Fragmentation splits into multiple smaller with % of original hp at low health
		##" ": 0, # 17 # Revives at % of the HP once, or HP has to be recuced to 0 multiple times, or Shatter and splits into n pieces with portion of the HP m times
	},
}
@export var Modifier: Dictionary = {}

func _ready() -> void:
	var group: String = get_parent().name
	add_to_group(group)
		
	##Debug
	while(!Global.Data.has("Minions")):
		continue
	Data.Equip.Minion[1] = Global.Data.Minions["Chibi"].keys().pick_random()

func spawn() -> void:
	var spawnin: Node = get_tree().get_first_node_in_group("Spawn")
	var minions: Node = get_tree().get_first_node_in_group("Minions")
	
	if is_in_group("temp"):
		return
	if Data.Equip.Minion[1] == "Select":
		return
	var instance:Node = minion.instantiate()
	instance.global_position = Vector2(spawnin.global_position.x,randi_range(-spawnin.scale.y,spawnin.scale.y))/2
	instance.name = str(instance.get_instance_id())
	instance.Data["Spawn"] = Data.Upgrades
	instance.Data.merge(Data.Upgrades)
	instance.Data.merge(Data.Properties)
	instance.Data.merge(Data.Equip)
	minions.add_child(instance)
