@tool
extends EditorPlugin

var button: Button

func _enter_tree() -> void:
	# Create the button
	button = Button.new()
	button.text = "Export & Run"
	button.pressed.connect(_on_button_pressed)

	# Add the button to the editor's top toolbar
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, button)

func _exit_tree() -> void:
	# Remove the button when the plugin is disabled
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, button)
	button.queue_free()

func _on_button_pressed() -> void:
	print("Exporting project...")

	# Define export parameters
	var export_path = "g:/Godot/Invicem2D_export/Invicem2D.exe"
	var preset_name = "Invicem2Dv2"
	var console_exe = "g:/Godot/Invicem2D_export/Invicem2D.console.exe"
	var run_args = [
		"--debug-server", "tcp://127.0.0.1:6007",
		"--remote-debug", "tcp://127.0.0.1:6007",
		"--verbose", "-1"
	]

	# Export the project using Godot’s command line
	var godot_path = OS.get_executable_path()
	var export_args = ["--headless", "--export-release", preset_name, export_path]
	
	var export_process = OS.create_process(godot_path, export_args)
	export_process.wait_to_finish()

	# Run the exported project with console
	print("Running exported project...")
	OS.execute(console_exe, run_args)  # 'false' ensures Godot doesn't freeze
