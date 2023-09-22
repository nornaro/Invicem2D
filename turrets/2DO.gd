extends Node

"""

1. One scene One thing
	-	Every modifier, or action should be on a seperate scene
2. Dynamic parameters as doctionary?
3. save templates as file (YAML?)
4. Function list:
	-	Targeting
	-	ATKing
		-	Homing ATK
		-	Area ATK
		-	Calculated ATK
	-	Splash
		-	Simple AoE
		-	Range from impact AoE
		-	body blockable from pmpact
		-	Splash targeting
	-	Overtime effects
	-	Item slots
	-	Upgrades
	-	Resource usage
		-	Resource types
			-	HR
			-	Power
			-	Mana
			-	Faith?
	-	modifier items, boosters, upgrades and stat allocation
		-	Store items as YML/LUA+PNG?
		-	Boosters boost one thing significantly
		-	Items modify basic behaviur, for example multitarget, trap placing etc.
		-	Upgrades can be made spending in-game currency or XP
		-	Stats can be redistributed to give extra for something else
			-	for exampe: give X% range, but take away Y% ASPD
5. Tower.Data
	@export var aoe = [1, 1] # centerradius, splashradius
	@export var aspd = [1, 1] # min, max
	@export var dmg = [1, 1] # min, max
	@export var tdelay = [0, 0] # targeting delay, first target, retarget
	@export var cooldown = [0, 0] # time aFter it has to stopm how long
		





ííííííííííí















"""
