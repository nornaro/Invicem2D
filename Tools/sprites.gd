@tool
extends EditorScript


var RL:ResLoad = ResLoad.new()
# Path to the existing 0.tres file (your Animations resource)
@export var base_resource_path: String = "res://Scenes/Minions/Chibi/0.tres"
# Folder where the image sequences are located
@export var folder_base_path: String = "res://Scenes/Minions/Chibi/"
# Output folder for saving the new .tres file
var sprites: Array
@export var extension: String = "webp"

func _run():
	# Automatically start the animation processing when the scene is ready (after F6)
	print_rich("Starting animation process...")
	sprites = ["Fallen_1"]#RL.get_directories_at(folder_base_path)
	for sprite in sprites:
		process_animations(sprite)

func process_animations(sprite):
	var base_resource : SpriteFrames = RL.load(base_resource_path)
	
	if base_resource == null:
		push_warning("Failed to load base resource (0.tres).")
		return
	
	# Assuming base_resource is a dictionary or array containing animation names
	var animation_names = base_resource.get_animation_names() # Replace with actual field if needed
	
	var sprite_frames = SpriteFrames.new() # New SpriteFrames resource for each animation
	for animation in animation_names:
		sprite_frames.add_animation(animation)
		var sprite_sequence_path = folder_base_path + sprite+ "/PNG Sequences/" + animation
		
		var files = get_files_in_directory(sprite_sequence_path)
		if files.is_empty():
			push_warning("No PNG files found for animation: " + animation)
			continue
		
		# Add the PNG files to the spriteframes
		var frames = []
		for file in files:
			var texture = RL.load(file)
			if texture is Texture:
				frames.append(texture)
		
		# Add frames to the animation
		for i: int in range(frames.size()):
			sprite_frames.add_frame(animation, frames[i])

		# Save the spriteframes as a .tres file
		var output_path = folder_base_path + sprite + ".tres"
		ResourceSaver.save(sprite_frames, output_path)
		print_rich("Saved spriteframes for " + sprite + " to " + output_path)

	# Quit the application after processing is complete
	print_rich("Process complete. Quitting the game.")


# Helper function to get files in the folder
func get_files_in_directory(directory_path: String) -> Array:
	var dir = RL.get_files_at(directory_path)
	var files: Array
	for file in dir:
		if file.ends_with("." + extension):
			files.append(directory_path + "/" + file)
	return files
