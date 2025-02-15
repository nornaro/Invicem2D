extends Node
class_name ResLoad

func open(path: String = "res://Scenes/Building/Academy/Academy.json", _mode: int = FileAccess.READ_WRITE) -> Resource:
	return ResourceLoader.load(path,"String")

func load(path: String) -> Resource:
	return ResourceLoader.load(path)
	
func list_directory(directory_path: String) -> Array:
	return ResourceLoader.list_directory(directory_path)

func get_files_at(directory_path: String) -> Array:
	var list:Array
	var cotents:Array = ResourceLoader.list_directory(directory_path)
	for c:String in cotents:
		if !c.ends_with("/"):
			list.append(c)
	return list

func get_directories_at(directory_path: String) -> Array:
	var list:Array
	var cotents:PackedStringArray = ResourceLoader.list_directory(directory_path)
	for c:String in cotents:
		if c.ends_with("/"):
			list.append(c.replace("/",""))
	return list

# Check if a file exists at a given path
func file_exists(path: String, hint: String = "") -> bool:
	return ResourceLoader.exists(path,hint)

func dir_exists(path: String, hint: String = "") -> bool:
	return ResourceLoader.exists(path,hint)
