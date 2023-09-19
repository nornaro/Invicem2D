extends Node2D

var color = "green"
@onready var Controls = $"../../../../Controls"

# Called when the node enters the scene tree for the first time.
func _ready():
	scale = $"..".mesh.size
	#$outline.scale = $"..".mesh.size
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$green.visible = false
	$red.visible = false
	if Controls.showCollision || Controls.showCollisionToggle:
		get_node(color).visible = true
	pass
