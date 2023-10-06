@tool
extends EditorPlugin

var keybindings: Dictionary = {
	KEY_A: "move_elem",
	KEY_S: "rotate_elem",
	KEY_D: "duplicate_elem",
	KEY_F: "select_all",
	KEY_Z: "toggle_snapping",
	KEY_X: "test_pattern",
	KEY_DELETE: "remove_elems",
	KEY_Q: "modify_s_delay",
	KEY_W: "modify_t_delay",
	KEY_E: "modify_speed",
	KEY_R: "modify_range",
	KEY_1: "rotate_parallel",
	KEY_2: "rotate_focused",
	KEY_3: "rotate_inwards",
	KEY_4: "rotate_outwards",
	KEY_5: "rotate_random"
}

const EDITOR_SCENE = preload("res://addons/projectiles_plugin/2d/editor/pattern_editor2d.tscn")

var editor_instance: Control
var editor_button: Button
var inspector_plugin: EditorInspectorPlugin


func _enter_tree():
	editor_instance = EDITOR_SCENE.instantiate()
	editor_instance.editor_interface = get_editor_interface()
	editor_instance.keybindings = keybindings
	editor_button = add_control_to_bottom_panel(editor_instance, "Projectiles Editor")
	
	inspector_plugin = load("res://addons/projectiles_plugin/inspector_plugin.gd").new()
	inspector_plugin.editor_plugin = self
	inspector_plugin.connect("pattern_selected", Callable(editor_instance, "load_pattern"))
	inspector_plugin.connect("pattern_selected", open_projectiles_editor)
	add_inspector_plugin(inspector_plugin)
#	editor_button.hide()
	add_types()


func add_types() -> void:
	add_custom_type("PatternShooter2D", "Node2D", preload("2d/patterns/pattern_shooter2d.gd"), preload("graphics/pattern_shooter.svg"))


func remove_types() -> void:
	remove_custom_type("PatternShooter2D")


func open_projectiles_editor(_a) -> void:
	make_bottom_panel_item_visible(editor_instance)


func _exit_tree():
	if editor_instance:
		remove_control_from_bottom_panel(editor_instance)
		editor_instance.free()
	if inspector_plugin:
		remove_inspector_plugin(inspector_plugin)
	remove_types()
