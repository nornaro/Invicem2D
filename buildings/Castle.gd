extends MeshInstance2D

@export var temp = false
@export var max_health = 1000
@export var base_health = 100
@export var min_health = 1
@export var health = base_health

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = Color(1, 1, 1, 1)
