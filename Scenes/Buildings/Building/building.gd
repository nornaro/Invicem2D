extends MeshInstance2D

@export var Data = {}

func _ready():
	Data["temp"]=true
	texture = load("res://Scenes/Buildings/Building/"+get_parent().name+".png")
	var script = load("res://Scenes/Buildings/Building/"+get_parent().name+".gd")
	
#	FileAccess.file_exists(script)
#	if FileAccess.file_exists(script):
#		set_script(script)
