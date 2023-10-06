@tool
extends Node2D
class_name PatternShooter2D

signal new_projectile_fired(projectile: Projectile2D)
signal all_fired()

@export var pattern: Pattern2D
@export var projectiles_group: String = ""

var tracked_projectiles: Array[WeakRef] = []
var projectiles_parent: Node
var left_to_fire: int = 0


func get_projectile_parent() -> Node:
	if projectiles_group.is_empty():
		return null
	return get_tree().get_first_node_in_group(projectiles_group)


func _ready() -> void:
	projectiles_parent = get_projectile_parent()
	if projectiles_parent == null:
		projectiles_parent = Node.new()
		projectiles_parent.name = "Projectiles"
		add_child(projectiles_parent)


func fire_pattern() -> void:
	if !pattern:
		return
	
	left_to_fire = pattern.data.size()
	for d in pattern.data:
		spawn_projectile(d)
	
	if left_to_fire <= 0:
		emit_signal("all_fired")


func clear() -> void:
	for c in get_children():
		if not c == projectiles_parent:
			c.queue_free()
	for p in tracked_projectiles:
		if p and p.get_ref():
			p.get_ref().queue_free()


func get_closest_target(pos: Vector2, group_name: String) -> Node2D:
	if group_name == "":
		return null
	var nodes: Array[Node] = get_tree().get_nodes_in_group(group_name)
	
	var min_dist: float = INF
	var closest_node: Node2D = null
	
	for n in nodes:
		if n is Node2D:
			var dist: float = pos.distance_to(n.global_position)
			if dist < min_dist:
				min_dist = dist
				closest_node = n
	return closest_node


func spawn_projectile(elem: PatternElem2D) -> void:
	var new_projectile: Projectile2D = elem.projectile.instantiate()
	
	new_projectile.trajectory = elem.trajectory
	new_projectile.global_position = global_position + elem.position.rotated(rotation)
	var target_obj: Node2D = get_closest_target(new_projectile.global_position, elem.target_group)
	if target_obj != null:
		new_projectile.travel_angle = rad_to_deg(Vector2(1, 0).angle_to(\
			target_obj.global_position - new_projectile.global_position))
	else:
		new_projectile.travel_angle = elem.angle + rotation_degrees
		new_projectile.travel_angle += (randf() - 0.5)*elem.rand_spread*360.0
	new_projectile.speed = elem.speed
	new_projectile.range = elem.range
	new_projectile.delay = elem.travel_delay
	new_projectile.speed_ramp = elem.speed_ramp
	new_projectile.run_in_editor = Engine.is_editor_hint()
	
	if elem.spawn_delay == 0.0:
		projectiles_parent.add_child(new_projectile)
		tracked_projectiles.append(weakref(new_projectile))
		emit_signal("new_projectile_fired", new_projectile)
	else:
		var timer: Timer = Timer.new()
		timer.wait_time = elem.spawn_delay
		timer.connect("timeout", Callable(self, "_on_spawn_delay_timeout").bind(new_projectile, timer))
		add_child(timer)
		timer.start()


func _on_spawn_delay_timeout(projectile: Projectile2D, timer: Timer) -> void:
	projectiles_parent.add_child(projectile)
	tracked_projectiles.append(weakref(projectile))
	timer.queue_free()
	emit_signal("new_projectile_fired", projectile)
	if left_to_fire <= 0:
		emit_signal("all_fired")


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if !pattern:
		warnings.append("Patter not assigned")
	return warnings
