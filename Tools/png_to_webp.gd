## Place this script in the "res://addons" folder and enable it in the editor.
@tool
extends EditorScript

const TARGET_PATH = "res://"

func _run() -> void:
	process_directory(TARGET_PATH)
	print_rich("Metadata added to all .tres files in", TARGET_PATH)

func process_directory(path: String) -> void:
	var files = DirAccess.get_files_at(path)
	for file_name in files:
		if file_name.ends_with(".tres"):
			process_tres(path + file_name)

	var directories = DirAccess.get_directories_at(path)
	for directory in directories:
		process_directory(path + directory + "/")

func process_tres(file_path: String) -> void:
	var resource := ResourceLoader.load(file_path)
	if resource:
		var changed = false
		for property in resource.get_property_list():
			if property["type"] == TYPE_STRING and ".png" in resource.get(property["name"]):
				resource.set(property["name"], resource.get(property["name"]).replace(".png", ".webp"))
				changed = true
		if changed:
			ResourceSaver.save(resource, file_path)
			print_rich("Updated:", file_path)
	else:
		push_error("Failed to load: " + file_path)
