extends Node


@export var Data: Dictionary = {
	"Properties": {
		"Power": "Normal", # Can put building ito overdrive for higher cost, it can disable, hurt or destroy building
		#"": "", # 
		#"": "", #
		#"": "", #
	},
	"Info": {},
	"Modules": {
		"Minion": ["Chibi", "Select", "Minion", "Module"], # SkinType, Skin
		"Dummy1": ["", "", "", "Module"],
		"Core": ["Basic", "Drained", "Core", "Module"], # Basic/Normal/Advanced/Exceptional, Empty/Drained/Low/""/Charged/Fully charged
		"Efficiency": ["Basic", "Low", "Efficiency", "Module"], # Basic/Normal/Advanced/Exceptional, Low,Medium,High
	},
	"Inventory": {},
	"Upgrades" : { #
		"Speed": 1, # 1 # Movement speed
		"HP": 1, # 2 # Maximum health
		"Defense": 0, # 3 # Reduce dmg recieved by fix amount, or %
		"Size": 1, # 4 # Increase Size&HP or reduce Size&HP and hitbox with it, % or amount
		"Shield": 0, # 5 # n hit or %HP barrier
		"Regeneration": 0, # 6 # As time passes, constant % or amount HP regen, or % regained on hit, or increase Size&HP, or regain % HP at % HP if not executed
		"SpeedBoost": 0, # 7 # If not eliminated in time, significantly increases speed for the finish
		"Efficiency": 0, # 8 # Energy efficiency of the Barrack
	},
}
"""
Innate:
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
Item:
	"Element": 
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
	"SpeedBoost":
		gives minion % speed boost based on hp%
		gives minion % speed boost based on Castle proximity
"""

func _ready() -> void:
	pass
