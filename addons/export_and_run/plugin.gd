@tool
extends EditorPlugin
#
#var button: Button
#
#var base_path = "g:/Godot/Invicem2D_export/"
#var export_path = "Invicem2D.exe"
#var preset_name = "Invicem2Dv2"
#var console_exe = "Invicem2D.console.exe"
#var run_args = [
	#"--debug-server", "tcp://127.0.0.1:6007",
	#"--remote-debug", "tcp://127.0.0.1:6007",
	#"--verbose", "-1"
#]
#
#var export_process_running = false
#var waiting_for_pck = false  # Flag to track waiting for .pck file
#
#func _enter_tree() -> void:
	#set_physics_process(false)  # Disable physics process initially
	## Ensure the plugin is loaded
	#print("Export&Run plugin loaded successfully!")
#
	## Create the button and set its properties
	#button = Button.new()
	#button.text = ">"
	#
	## Connect the 'pressed' signal to the _on_button_pressed method
	#button.pressed.connect(_on_button_pressed)
#
	## Add the button to the editor's top toolbar
	#add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, button)
#
	## Only cleanup on explicit button press or F7 key press, not when the editor starts
	## _cleanup_previous_exports() is no longer called in _enter_tree()
#
#func _exit_tree() -> void:
	#set_physics_process(false)  # Disable physics process when exiting
	## Remove the button when the plugin is disabled
	#print("Export&Run plugin unloaded.")
	#remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, button)
	#button.queue_free()
#
## Function to clean up previous exports (called when plugin loads)
#func _cleanup_previous_exports() -> void:
	#print("Cleaning up previous exports...")
	#var cleanup_path = base_path + "*.*"
	#var command = "powershell"
	#var args = ["-Command", "Remove-Item", cleanup_path, "-Force"]
	#
	## Capture the command's output
	#var output = []
	#var result = OS.execute(command, args)  # Run the command and capture output
#
## Helper function to check if a directory is empty
#func _is_directory_empty(directory_path: String) -> bool:
	#return DirAccess.get_files_at(directory_path).is_empty()
#
## Function to start the export process
#func _start_export_process() -> void:
	#if export_process_running:
		#print("Export process already running.")
		#return
#
	#print("Exporting project...")
	#var godot_path = OS.get_executable_path()
	#var export_args = ["--headless", "--export-release", preset_name, base_path + export_path]
	#
	## Run export process	
	#print("Running export process...")
	#export_process_running = true
	#var result = OS.execute(godot_path, export_args)  # Wait for export to finish
#
	#if result != OK:
		#print("Export failed.")
		#export_process_running = false
		#return
#
	#export_process_running = false
	#print("Export successful. Now running the exported project.")
#
	## Begin waiting for the .pck file to be created
	#waiting_for_pck = true
	#set_physics_process(true)  # Enable physics process to check for .pck file
#
## Function to run the exported project
#func _run_exported_project() -> void:
	## Run the exported project with the console app
	#var result = OS.execute(base_path + console_exe, run_args)  # Run the console app with arguments
	#if result != OK:
		#print("Failed to run the exported project.")
	#else:
		#print("Exported project running.")
#
## Define the _on_button_pressed function (for button press event)
#func _on_button_pressed() -> void:
	## This method will be triggered when the button is pressed
	#print("Button pressed! Starting the export process...")
	#_cleanup_previous_exports()
#
#func _input(event: InputEvent) -> void:
	## Check if the event is a key press and specifically the F7 key
	#if event is InputEventKey:
		#if event.pressed and event.keycode == KEY_F7:
			## Call the same function as the button press when F7 is pressed
			#_on_button_pressed()
#
## The _physics_process function to check for .pck file
#func _physics_process(delta: float) -> void:
	## Check if the directory is empty first
	#if _is_directory_empty(base_path):
		#_start_export_process()
		#return
	#if FileAccess.file_exists( base_path + "Invicem2D.pck"):
		#print("Running the exported project...")
		#_run_exported_project()
		#waiting_for_pck = false  # Stop waiting
		#set_physics_process(false)  # Disable physics process when done
		#return  # Exit the physics process early to avoid checking the file constantly
	#return  # If export is running, don't start another process
