extends Panel


func _ready() -> void:
	var directories = DirAccess.get_directories_at("res://Scenes/MainMenu/HomeButtons/")
	for dir in directories:
		var data =  dir.split("_")
		get_node(data[0]).load_buttons(data)
