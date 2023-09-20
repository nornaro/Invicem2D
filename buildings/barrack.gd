extends MeshInstance2D

@export var temp = true

@onready var spawn = $"../../../Map/Spawn/CollisionShape2D"
var minion_scene = preload("res://minion.tscn")
var elapsed_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
		
func spawn_minion(minionspath):
	var minion_instance = minion_scene.instantiate()
	minion_instance.position = Vector2(spawn.position.x,randi_range(-spawn.scale.y,spawn.scale.y))
	minionspath.add_child(minion_instance)


func _on_area_2d_mouse_entered():
	pass # Replace with function body.
