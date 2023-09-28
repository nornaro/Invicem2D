extends MeshInstance2D

var elapsed_time
var in_range
@export var temp = true
@export var targeting = []

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
	"projectile": "HomingProjectile",
	"menu" : ""
}
"
Slots:
	Targeting
	Turret
	Item[4]
"

"""

func _ready():
	$Min/CollisionShape2D.shape.radius = Tower.Data["targetingRrange"][0]
	$Max/CollisionShape2D.shape.radius = Tower.Data["targetingRrange"][1]

func _process(_delta):
	if targeting.size() < Tower.Data["aoe"][0]:
		for target in in_range:
			in_range.erase(target)
			if is_instance_valid(target):
				targeting.append(target)


"""
func _on_min_area_exited(area):
	add(area)

func _on_max_area_entered(area):
	if !area.get_parent().is_in_group("minions"):
		return
	in_range.append(area)
	add(area)
		
func _on_min_area_entered(area):
	del(area)

func _on_max_area_exited(area):
	del(area)

func add(area):
	if !area.get_parent().is_in_group("minions"):
		return
	if targeting.size() < Data["aoe"][0]:
		in_range.erase(area)
		targeting.append(area)

func del(area):
	if !area.get_parent().is_in_group("minions"):
		return
	if area in targeting:
		targeting.erase(area)


func _ready():
#	$Min/CollisionShape2D.shape.radius = Tower.Data["targetingRrange"][0]
#	$Max/CollisionShape2D.shape.radius = Tower.Data["targetingRrange"][1]
	$Outline.width *= 0.8
	$Outline.hide()

func instance_scene_from_name(turret_name: String): # testing function
	var instance = AnimatedSprite2D.new()
	instance.name = turret_name
	var sprite_frames=SpriteFrames.new()
	sprite_frames = load("res://Scenes/Building/Tower/Turrets/"+turret_name+"/"+turret_name+".tres")
	instance.sprite_frames = sprite_frames
	add_child(instance)
	return instance.get_instance_id()

func _process(delta):
	if !Data.has("projectile"):
		return
	if !Data.has("aspd"):
		return
	if targeting.size() == 0:
		return
	elapsed_time += delta
	if elapsed_time < 1 / Data["aspd"][1]:
		return
	elapsed_time = 0.0
	for target in targeting:
		if is_instance_valid(target):
			fire_projectile(target.get_parent())

func fire_projectile(target):
	var scene = load("res://Scenes/Building/Tower/Projectiles/"+Data["projectile"]+".tscn")	
	var instance = scene.instantiate()
	instance.position += Vector2(0,60)
	instance.target = target
	add_child(instance)

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
