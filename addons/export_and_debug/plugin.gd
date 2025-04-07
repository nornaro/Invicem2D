@tool
extends EditorPlugin

@export var export_folder: String = ".Export"
## Button for starting the export process.
var button: Button

## Store pids for runs in case kill was not a success
var previous_pids: Array

## Process ID for running project 
var pid: int

## Steps of cleaning, buildign amd running
var step: int = 0

## The project name retrieved from project settings.
var project_name: String = ProjectSettings.get_setting("application/config/name")

## Path variables.
var base_path: String
var export_path: String = project_name + ".exe"
var console_exe: String = project_name + ".console.exe"

## Arguments for remote debugging.
var run_args = [
	"--debug-server", "tcp://127.0.0.1:6007",
	"--remote-debug", "tcp://127.0.0.1:6007",
	"--verbose", "-1",
]

func _ready() -> void:
	set_physics_process(false)

func _enter_tree() -> void:
	if not ProjectSettings.has_setting("global/export_folder"):
		ProjectSettings.set_setting("global/export_folder", export_folder)
		ProjectSettings.set_initial_value("global/export_folder", export_folder)
	export_folder = ProjectSettings.get_setting("global/export_folder")
	base_path = ProjectSettings.globalize_path("res://") + export_folder + "/"

	set_physics_process(false)

	button = Button.new()
	button.text = ">"
	button.tooltip_text = "Remote Debug (F7)"
	button.pressed.connect(_on_button_pressed)
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, button)

func _exit_tree() -> void:
	set_physics_process(false)
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, button)
	button.queue_free()

# Function to clean up previous exports (called when the plugin loads)
func _cleanup_previous_exports() -> void:
	if step == 2:
		return
	for file in DirAccess.get_files_at(base_path):
		while(DirAccess.remove_absolute(base_path+file)): continue
	while(DirAccess.remove_absolute(base_path)): continue
	DirAccess.make_dir_recursive_absolute(base_path)
	set_physics_process(true)
	step = 2

# Function to start the export process
func _start_export_process() -> bool:
	var godot_path = OS.get_executable_path()
	var export_args = ["--headless", "--export-debug", "debug", base_path + export_path]
	var res = OS.create_process(godot_path, export_args)
	return res
	
# Define the _on_button_pressed function (for button press event)
func _on_button_pressed() -> void:
	if Input.is_key_pressed(KEY_CTRL):
		open_export_folder_in_file_explorer()
		return
	if step > 0:
		return
	step = 1
	get_editor_interface().stop_playing_scene()
	
	_kill_exported_process(previous_pids)
	_cleanup_previous_exports()

# Function to open the export folder in the file explorer
func open_export_folder_in_file_explorer() -> void:
	if export_folder == "":
		push_error("Export folder is not set!")
		return
	# Open the folder in file explorer
	OS.shell_open(export_folder)

func _input(event: InputEvent) -> void:
	if Input.is_physical_key_pressed(KEY_F7):
		_on_button_pressed()

func _physics_process(delta: float) -> void:
	push_warning(step)
	var res: int
	
	# Ensure that direcctory cleaning actually finished
	if !DirAccess.get_files_at(base_path):
		step += 3
	if step < 3:
		_cleanup_previous_exports()
		return
		
	# Ensure that cleanup is done before starting the export.
	if DirAccess.dir_exists_absolute(base_path):
		res = _start_export_process()
		step = 4
	if step < 4:
		return
	
	# Only start after every other step is done.
	pid = OS.create_process(base_path + console_exe, run_args)
	previous_pids.append(pid)
	push_warning(previous_pids)
	step = 0
	set_physics_process(false)

func _kill_exported_process(pids: Array) -> void:
	previous_pids.clear()
	for p: int in pids:
		if OS.kill(p):
			previous_pids.append(p)
		await(get_tree().create_timer(2).timeout)
