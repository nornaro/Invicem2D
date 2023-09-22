extends MeshInstance2D

@export var Data = {}

func _ready():
	Data["temp"]=true
	texture = load("res://Scenes/Buildings/Building/"+get_parent().name+".png")
	var _script = load("res://Scenes/Buildings/Building/"+get_parent().name+".gd")
