extends Control

var path: String = "res://Scenes/Building/Academy/Academy.json"

func asdf():
	var file = FileAccess.new
	var json = JSON.new()
	var parsing_state: Error = json.parse(file.get_line())
	if parsing_state != OK:
		return
	var state: Dictionary = json.get_data()


func _ready() -> void:
	var json = JSON.new()
	#json.parse_string(ResourceLoader.load(path))
	json.stringify(ResourceLoader.load(path))
	print(json)
	print(ResourceLoader.exists(path))
	print(ResourceLoader.load(path).get_data())
	print(ResourceLoader.load(path).parse())
	#print(ResourceLoader.load(path,"GDScript").get_script())
	#print(ResourceLoader.load(path,"GDScript").get_property_list())
	#print(ResourceLoader.load(path,"GDScript").to_string())
	print(ResourceLoader.load(path,"Script"))
	#print(ResourceLoader.load(path,"Script").get_script())
	print(ResourceLoader.load(path,"Script").get_property_list())
	print(ResourceLoader.load(path,"Script").to_string())
	print(ResourceLoader.load(path,"String"))
	print(ResourceLoader.load(path,"String").get_script())
	print(ResourceLoader.load(path,"String").get_property_list())
	print(ResourceLoader.load(path,"String").to_string())
