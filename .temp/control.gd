extends Control

#var path: String = "res://Scenes/Building/Academy/Academy.json"
#
#func asdf():
	#var file = FileAccess.new
	#var json = JSON.new()
	#var parsing_state: Error = json.parse(file.get_line())
	#if parsing_state != OK:
		#return
	#var state: Dictionary = json.get_data()


#func _ready() -> void:
	#var json = JSON.new()
	#json.stringify(ResourceLoader.load(path))
