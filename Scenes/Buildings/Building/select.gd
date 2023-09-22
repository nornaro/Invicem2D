extends Node2D

var color = "green"
@onready var Controls = $"../../../../Controls"

# Called when the node enters the scene tree for the first time.
func _ready():
	scale = $"..".mesh.size
	
# 2DO	
#	$green.visible = false
#	$red.visible = false
#	if !Controls:
#		return
#	if Controls.showCollision || Controls.showCollisionToggle:
#		get_node(color).visible = true
