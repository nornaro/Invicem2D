@tool
extends EditorScript

var folders:Dictionary

func _run(root:String = "res://Scenes/") -> void:
	for folder in DirAccess.get_directories_at(root):
		folders[folder] = root+folder+"/"
		_run(folders[folder])
	print(folders)
