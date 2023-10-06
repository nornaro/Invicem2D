extends Resource
class_name PatternElem2D

@export var projectile: PackedScene
@export var position: Vector2
@export var angle: float
@export var trajectory: Trajectory2D = LinearTrajectory2D.new()
@export var speed: float = 10.0
@export var speed_ramp: Curve = null
@export var range: float = 100.0
@export var spawn_delay: float = 0.0
@export var travel_delay: float = 0.0
@export_range(0.0, 1.0) var rand_spread: float = 0.0
@export var target_group: String = ""

