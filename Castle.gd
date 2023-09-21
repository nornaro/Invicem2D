extends Node

@onready var Castle = preload("res://buildings/Castle.tscn")
# Called when the node enters the scene tree for the first time.

func _ready():
	var instance = Castle.instantiate()
	add_child(instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
