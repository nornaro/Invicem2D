extends RigidBody2D

var lua: LuaAPI = LuaAPI.new()
var projectileSpeed = [0, 0] # min, max
var target = null  
var speed = 0

func _ready():
	add_to_group("projectiles")
	lua.bind_libraries(["base"])
	var err: LuaError = lua.do_file("res://Scenes/Building" + Global.style + "//Tower/Targeting/Homing.lua")
	
	if err is LuaError:
		push_warning("ERROR %d: %s" % [err.type, err.message])

func _process(delta):
	var ret = lua.call_function("shoot_logic", [delta, speed, projectileSpeed])
	if ret is LuaError:
		push_warning("ERROR %d: %s" % [ret.type, ret.message])
		return
	speed = ret
	if is_instance_valid(target):
		linear_velocity = (target.global_position - global_position - Vector2(target.speed, 0)).normalized() * projectileSpeed[0]
	if !is_instance_valid(target):
		queue_free()

func hit(area):
	var hp = lua.call_function("hit_logic", [area, mass])
	if hp is LuaError:
		push_warning("ERROR %d: %s" % [hp.type, hp.message])
		return
	if hp <= 0:
		area.get_parent().queue_free()
