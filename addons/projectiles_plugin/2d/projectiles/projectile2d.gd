@tool
extends Area2D
class_name Projectile2D

signal body_hit(projectile: Projectile2D, body: Node2D)
signal max_range_reached(projectile: Projectile2D)

@export var damage: float = 1.0

var range: float = 100.0
var speed: float = 10.0
var speed_ramp: Curve = null
var delay: float = 0.0

var trajectory: Trajectory2D
var travel_angle: float = 0.0

var dist: float = 0.0
var rot: bool = false
var wait_for_delay: bool = false
var run_in_editor: bool = false

@onready var dist_left: float = range


# Override in inherited class for custom behaviour
func _on_body_entered(body: Node2D) -> void:
	if body.has_method('damage'):
		body.damage(damage)
		emit_signal("body_hit", self, body)
	queue_free()


func _ready() -> void:
	if Engine.is_editor_hint() and not run_in_editor:
		return
	connect("body_entered", _on_body_entered)
	rot = travel_angle != 0.0
	wait_for_delay = delay > 0.0


func end_path() -> void:
	emit_signal("max_range_reached", self)
	queue_free()


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint() and not run_in_editor:
		set_physics_process(false)
		return
	if !trajectory:
		return
	
	if wait_for_delay:
		delay -= delta
		wait_for_delay = delay > 0.0
		return
	if dist_left <= 0:
		end_path()
		return
	var s: float = speed
	if speed_ramp:
		s = speed_ramp.sample(dist/range)
	var dt: float = delta*s
	dist += dt
	dist_left -= dt
	var move_delta: Vector2 = trajectory.get_delta(dt, dist)
	if rot:
		move_delta = move_delta.rotated(deg_to_rad(travel_angle))
	position += move_delta

