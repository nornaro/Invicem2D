extends Node


"""
home
	mp
"""

""" High Prio:
	-Separate HUD
	-MultiPlayer
	-Leaderboard - partially working
	- Items, Modules, Inventory
	- Resource usage
	when hosting, start the console with parameter instead of changing the current instance
"""


"""
- save templates as file (YAML?)
- transform logic (like unit movement, projectiles, targeting) to c#
- sync enemy turrets, setting and upgrade for viewing data, skill to show enemy map maybe?
- Function list:
	#-	Targeting
		#-	fixed
		#-	fifs
		#-	lp
		#-	ground
		#-	random
		#-	focused
	- Trajectory
		- Ballistic: fixed length based on projectile speed, up, fixed g down, bell curve from A to B, DMG around impact
	#-	ATKing
		#-	Homing ATK
		#-	Area ATK
		#-	Calculated ATK
	-	Splash Item
		-	Simple AoE
		-	Range from impact AoE
		-	body blockable from impact
		-	Splash targeting
	-	Overtime effects
	-	Item slots
	-	Upgrades
		- Turret
			#- multishot: shoots smaller projectiles, that have smaller damage, always double the projectile count, 50% the damage, increase +5% for 3 LVLs, this becomes 8 * 56,25 = 450% dmg
			#- spread: slightly deviate from target with range, can be lowered to pinpoint
			- flak: lower both aspd dmg significantly, but shoot shitton of fragments
		- projectile: 
			- multitarget: same as before, but shoots at different targets, baries aspd instead of dmg
		- barrack:
			-
		- minion:
			#- size gives things
			#- crit
			#- crit resist
			#- crit chance
	- Innate:
		- turret:
			- targeting land/air/both
		- minion:
			- "movement": Air/Land/Hover
			- "Evasion": 0, # 10 # everx n hits it blocks the next m, % chance to block
			- "LootDrop": 0, # 5 # 5% less chance to drop item, or -1 item level -> Combine 16 to gain Lootless
			- "Stealth": 0, # 9 # onhit or periodic -> Combine 16 to gain pemanent
			- "CCResist": 0, # 12 # Reduce the efficiency or chance of all CC -> Combine 16 to gain immun
			#- "CritResist": 0, # 13 # Reduce the efficiency or frequency of Crit, at max lvl gain immun
			- "LessBounty": 0, # 14 # Reduce the ammount of bounty the other player gets -> Combine 16 to gain Lootless
			- "Divide": 0, # 16 # Multiplying after time, Mass Production Spawns multiple of the unit, but with less HP, Fragmentation splits into multiple smaller with % of original hp at low health
			- "Revive": 0, # 17 # Revives at % of the HP once, or HP has to be recuced to 0 multiple times, or Shatter and splits into n pieces with portion of the HP m times
	-	Resource usage
		-	Resource types
			-	HR
			-	Power
			-	Money
	-	modifier items, boosters, upgrades and stat allocation
		-	Store items as YML/LUA+PNG?
		-	Boosters boost one thing significantly
		-	Items modify basic behaviur, for example multitarget, trap placing etc.
		-	Upgrades can be made spending in-game currency or XP
		-	Stats can be redistributed to give extra for something else
			-	for exampe: give X% range, but take away Y% ASPD
- make every aspekt work with 2D, 2.5D, 3D assets
"""

""" Low Prio
	#New building ()
	#Networking (UDP, WS, Steam,Epic, Jam, GDS,...)
"""
