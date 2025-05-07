extends ScrollContainer

var minion_data:PackedScene = preload("res://Scenes/UI/minion_data.tscn")
var minions_path:String = "res://Scenes/Minions/"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var minions: Dictionary
	for minion_type:String in DirAccess.get_directories_at(minions_path):
		for minion in DirAccess.get_directories_at(minions_path+minion_type):
			if minions.has(minion.split("_")):
				continue
