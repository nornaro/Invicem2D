## Place this script in the "res://addons" folder and enable it in the editor.
@tool
extends EditorScript

const TARGET_PATH = "res://Scenes/Minions/Chibi/"

func _run() -> void:
	var files = DirAccess.get_files_at(TARGET_PATH)
	if files.is_empty():
		push_error("No files found in directory: " + TARGET_PATH)
		return
	for file_name in files:
		if file_name.ends_with(".tres"):
			process_tres(TARGET_PATH + file_name)
	print_rich("Metadata added to all .tres files in", TARGET_PATH)

func process_tres(file_path: String) -> void:
	var resource := ResourceLoader.load(file_path)
	if !resource:
		push_error("Failed to load: " + file_path)
		return
	resource.set_meta("position", Vector2(0, 0))
	resource.set_meta("scale", Vector2(1, 1))
	resource.take_over_path(file_path)  # Ensures the resource is marked as modified
	#ResourceSaver.ResourceSaver(resource, file_path)
	print_rich("Updated:", file_path)
