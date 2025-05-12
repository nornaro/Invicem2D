extends StaticBody2D
class_name Barrack

@onready var minion_scene:PackedScene
var spawnin: CollisionShape2D
var spawnog: CollisionShape2D
var minions: Node

@export var Data: Dictionary = { # Barrack is responsible for producing minion every turn, based on Data
	"Properties": { 
		"Power": "Balanced",
			# Disabled – 0% work speed, 1% energy consumption
			# Reduced - 50% work speed, 25% energy consumption
			# Optimized – 90% work speed, 75% energy consumption (stats increased 10%)
			# Balanced – 100% work speed, 100% energy usage. (no changes)
			# High – 125% work speed, 150% energy usage. May reduce quality (stats reduced 25%)
			# Overdrive – 150% work speed, 200% energy usage. May reduce quality (stats reduced 50% chance, properties missing 10% chance, damage building upgrade 1% chance)
			# Extreme – 200% work speed, 400% energy usage. (stats reduced, properties missing 25% chance, damage building upgrade 1% chance, destroy building upgrade 0,01% chance)
		"Mode": "Balanced",
			# Wasteful – 110% work speed, 115% energy consumption
			# Balanced – 100% work speed, 100% energy consumption
			# Optimized – 90% work speed, 85% energy consumption
			# Efficiet – 85% work speed, 70% energy consumption
		"Deployment": "Standard",
			# Standard – Every turn
			# Pair - Every 1-3 turns
			# Batch – Every 4-6 turns
			# Wave - Every 6-9 turns
		"Focus": "HP",
			# "HP": +4 points
			# "Defense": +4 points
			# "Size": +4 points
			# "Shield": +4 points
	},
	"Info": {},
	"Modules": { # changes what and if minion is produced
		"Minion": [], #["Chibi", "Satyr", "Minion"], # SkinType, Skin
		"Tier": ["Simple", "Basic", "Tier"], # Produce stronger minions, but at what cost?
			# Simple → Only standard minions can be created. (no effect)
			# Specialized → Limits minion types but boosts some quality.
			# Experimental → Has a chance to modify minions randomly.
			# ,
			# Basic → Only standard minions can be created. Green
			# Advanced → Allows production of stronger minions. Blue
			# Elite → Allows production of powerful minions. Yellow
			# Boss -> Allows production of boss minions. Red
		"Core": ["Basic", "Drained", "Core"], # Basic[0-2]/Normal[0-3]/Advanced[0-4]/Exceptional[0-5], [0-5] Empty/Drained/Low/Draining/Charged/Fully charged
		"Efficiency": ["Basic", "Low", "Efficiency"], # Basic/Normal/Advanced/Exceptional, Low,Medium,High
	},
	"Inventory": {}, # Additional minion properties, or modified minion properties
	"Upgrades" : { # changes basic stats for minion, or power efficiency of building
		"Speed": 1, # 1 # Movement speed
		"HP": 1, # 2 # Maximum health
		"Defense": 0, # 3 # Reduce dmg recieved by fix amount, or %
		"Size": 1, # 4 # Increase Size&HP or reduce Size&HP and hitbox with it, % or amount
		"Shield": 0, # 5 # n hit or %HP barrier
		"Regeneration": 0, # 6 # As time passes, constant % or amount HP regen, or % regained on hit, or increase Size&HP, or regain % HP at % HP if not executed
		"Efficiency": 0, # 9 # Energy efficiency of the Barrack
	},
}
"""
Minion Innate Properties:
	"Element": 
		Different element, different dmg multiplier
	"Armor": 
		none, 
		defense * % reduction, 
		defense * amount reduction
	"Movement": (changes what damage applies, what can target it)
		ground vs 
		air 
	"Evasion":
		everx n hits it blocks the next m, 
		% chance to block
	"Stealth": 0, 
		onhit
		periodic
	"CCResist": (some or all CC)
		reduce the efficiency of CC
		reduce the duration of CC
		reduce the chance of CC 
	"CritResist":
		reduce lvl of Crit
	"LessBounty":
		reduce the ammount of bounty the other player gets by %
		reduce the loot chance by %
		reduce the loot lvl
	"Divide":
		multiplying after time alive
		spawns multiple of the unit but with less stats
		fragmentation splits into multiple smaller with % of original hp at low health
	"Deny death": 
		revives at % of the HP once
		Returns to new max_hp at max_hp/2 from low % hp unless hit to 0 with last hit from %
	"Sabotage": (stackable)
		appy negative effect on turret
	"SpeedBoost": (non stackable)
		gives minion % speed boost based on hp%
		gives minion % speed boost based on Castle proximity
Barrack Item:
	"Element": (non stackable)
		Changes element
	"Armor": (stackable)
		additional % reduction
		additional amount reduction
	"Movement": (non stackable)
		chages to air
	"Evasion": (non stackable)
		every n hits, it blocks the next m hits
		% chance to block
	"Stealth": (stackable) 4 to gain pemanent
		% chance onhit
		every n hit
		periodic, use  
	"LessBounty": (stackable)
		reduce the ammount of bounty the other player gets by %
		reduce the loot chance by %
		reduce the loot lvl
	"Divide": (non stackable)
		multiplying after time alive
		spawns multiple of the unit but with less stats
		fragmentation splits into multiple smaller with % of original hp at low health
	"Deny death": (non stackable)
		revives at % of the HP once
		Returns to new max_hp at max_hp/2 from low % hp unless hit to 0 with last hit from %
	"Sabotage": (stackable)
		appy negative effect on turret
	"SpeedBoost": (non stackable)
		gives minion % speed boost based on hp%
		gives minion % speed boost based on Castle proximity
"""
@export var Modifier: Dictionary = {}

func _ready() -> void:
	minion_scene  = preload("res://Scenes/Minions/minion.tscn")
	spawnin = Global.GetTree.get_first_node_in_group("Spawn")
	minions = Global.GetTree.get_first_node_in_group("Minions")
	#var group: String = get_class()
	add_to_group("Barrack")
		
	##Debug
	while(!Global.Data.has("Minions")):
		continue
	#Data.Modules.Minion[1] = Global.Data.Minions["Chibi"].values().pick_random()

func spawn(data: Dictionary) -> void:
	if is_in_group("temp"):
		return
	if !Data.Modules.Minion:
		Data.Modules.Minion = ["Chibi", Global.Data.Minions["Chibi"].keys().pick_random(), "Minion"]
		#return
	if Data.Modules.Minion[1] == "Select":
		return

	var instance: Minion = minion_scene.instantiate()
	if !data.has("global_position"):
		if Data.Modules.Minion.size() == 0:
			return
		data.global_position = spawnin.global_position
		data["name"] = str(instance.get_instance_id())
		data["id"] = multiplayer.get_unique_id()
		data["Spawn"] = Data.Upgrades
		data.merge(Data.Upgrades)
		data.merge(Data.Properties)
		data.merge(Data.Modules)
	
	data.global_position += Vector2(randf_range(-35,35),randf_range(-35,35))
	
	if !data.has("dead"):
		data["name"] = str(instance.get_instance_id())
		data["id"] = multiplayer.get_unique_id()
		
	if data.has("dead"):
		instance.dead = data.dead

	var old_minion: Node = minions.get_node_or_null(str(data.name))
	if old_minion:
		minions.call_deferred("remove_child","old_minion")
		old_minion.queue_free()
	
	if !data.has("minion_sprite"):
		data["minion_class"] =  Global.Data.Minions.keys().pick_random()
		data["minion_race"] =   Global.Data.Minions[data["minion_class"]].keys().pick_random()
		data["minion_sprite"] = Global.Data.Minions[data["minion_class"]][data["minion_race"]].keys().pick_random()
	
	instance.Data = data
	instance.name = data.name
	instance.global_position = data.global_position
	instance.add_to_group("minions")
	instance.get_node("MinionArea").set_meta("owner", data.id)
	minions.call_deferred("add_child",instance)
