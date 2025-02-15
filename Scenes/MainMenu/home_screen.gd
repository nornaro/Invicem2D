extends Panel


func _ready() -> void:
	var directories:Array = Global.RL.get_directories_at("res://Scenes/MainMenu/HomeButtons/")
	for dir:String in directories:
		var data:Array =  dir.split("_")
		get_node(data[0]).load_buttons(data)
