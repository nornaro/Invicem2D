extends Node2D

var arr = [5,6,7]

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 4:
		arr.append(i)
		arr.erase(4)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
