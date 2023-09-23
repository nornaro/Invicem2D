extends MeshInstance2D

@export var Data = {}

func _ready():
	Data["temp"]=true
	Data["selected"]=false
	add_to_group(get_parent().name)
	texture = load("res://Scenes/Buildings/Building/"+get_parent().name+".png")
	var script = "res://Scenes/Buildings/Building/"+get_parent().name+".gd"
	FileAccess.file_exists(script)
	if FileAccess.file_exists(script):
		set_script(load(script))
