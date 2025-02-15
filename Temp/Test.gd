extends Node2D

var arr = [5,6,7]

# Called when the node enters the scene tree for the first time.
func _ready():
	for i: int in 4:
		arr.append(i)
		arr.erase(4)
