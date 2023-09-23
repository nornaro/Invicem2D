extends MeshInstance2D

@export var temp = true
@export var targeting =[]
@export var Data = { # testing data
	"targetingRrange" : [10, 600], # min, max
	"aoe" : [4, 1], # targets, splash
	"aspd" : [1, 1], # min, max
	"dmg" : [1, 1], # min, max
	"targetingDelay" : [0, 0], # targeting delay, first target, retarget
	"cooldown" : [0, 0], # time aFter it has to stopm how long
	"projectileSpeed" : [500, 500], # min, max
	"type": ["Bullet", "Arrow", "Magic"],
	"element": ["Earth", "Wind", "Fire", "Water", "Physical", "Ether", "Energy", "Electric", "Poison", "Corrosive"],
	"projectile": "HomingProjectile"
}

func _ready():
	Data["selected"]=false
	print("azazaz")
	pass

func instance_scene_from_name(_scene_name: String):
	var scene = load("res://Scenes/Buildings/Building/Turrets/Turret.tscn")
	var instance = scene.instantiate()
	#instance.position = position
	add_child(instance)
	return instance.get_instance_id()
