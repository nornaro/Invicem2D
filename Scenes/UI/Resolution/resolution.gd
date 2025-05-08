extends VBoxContainer

@onready var resolution_option_button: Node = $Resolution_OptionButton
@onready var full_screen_check_box: Node = $FullScreen_CheckBox
@onready var scale_label: Node = $ScaleBox/ScaleLabel
@onready var scale_slider: Node = $ScaleBox/ScaleSlider
@onready var scale_name: Node = $ScaleBox/ScaleName
@onready var fsr_options: Node = $FSROptions
@onready var vsync_checkbox: Node = $vsync_checkbox
@onready var screen_selector: Node = $Screen_Selector

var Resolutions: Dictionary = {
	"4096x2560": Vector2i(4096, 2560),
	"3840x2160": Vector2i(3840, 2160),
	"2560x1440": Vector2i(2560, 1440),
	"1920x1080": Vector2i(1920, 1080),
	"1366x768": Vector2i(1366, 768),
	"1536x864": Vector2i(1536, 864),
	"1280x720": Vector2i(1280, 720),
	"1440x900": Vector2i(1440, 900),
	"1600x900": Vector2i(1600, 900),
	"1024x600": Vector2i(1024, 600),
	"960x540": Vector2i(960, 540),
	"800x600": Vector2i(800, 600),
	"640x360": Vector2i(640, 360),
	"480x320": Vector2i(480, 320),
	"480x270": Vector2i(480, 270),
	"320x200": Vector2i(320, 200),
	"320x180": Vector2i(320, 180),
}

const FSR_SCALES = {
	0: {"label": "Potato", "scale": 33},
	1: {"label": "Performance", "scale": 50},
	2: {"label": "Balanced", "scale": 58},
	3: {"label": "Quality", "scale": 67},
	4: {"label": "Ultra", "scale": 77},
	5: {"label": "Off", "scale": 100},
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_resolutions()
	check_variables()
	get_screens()

func check_variables() -> void:
	var _window: Window = get_window()
	var mode: int = _window.get_mode()

	if mode == Window.MODE_FULLSCREEN:
		resolution_option_button.set_disabled(true)
		full_screen_check_box.set_pressed_no_signal(true)

	if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED:
		vsync_checkbox.set_pressed_no_signal(true)

func set_resolution_text() -> void:
	var Resolution_Text: String = str(get_window().get_size().x) + "x" + str(get_window().get_size().y)
	resolution_option_button.set_text(Resolution_Text)
	scale_slider.set_value_no_signal(100.00)

func add_resolutions() -> void:
	var ID: = 0
	for r:String in Resolutions.keys():
		resolution_option_button.add_item(r)
		if Resolutions[r] == get_window().get_size():
			resolution_option_button.select(ID)
		ID += 1

func _on_option_button_item_selected(index: int) -> void:
	var ID: String = resolution_option_button.get_item_text(index)
	Set_Resolution(Resolutions[ID])

func Set_Resolution(res: Vector2i) -> void:
	get_window().set_size(res)
	set_resolution_text()
	centre_window()

func centre_window() -> void:
	var Centre_Screen: Vector2 = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	var Window_Size: Vector2 = get_window().get_size_with_decorations()
	get_window().set_position(Centre_Screen - Window_Size / 2)

func _on_full_screen_check_box_toggled(toggled_on: bool) -> void:
	resolution_option_button.set_disabled(toggled_on)
	if toggled_on:
		get_window().set_mode(Window.MODE_MAXIMIZED)
	if !toggled_on:
		get_window().set_mode(Window.MODE_WINDOWED)
		centre_window()

	get_tree().create_timer(.05).timeout.connect(set_resolution_text)

func _on_scale_slider_value_changed(value: float) -> void:
	var _viewport: Viewport = get_viewport()
	var fsr: Dictionary = FSR_SCALES.get(int(value), {"label": "Unknown", "scale": 100})
	_viewport.set_scaling_3d_mode(Viewport.SCALING_3D_MODE_BILINEAR)
	if fsr["scale"] == 100:
		_viewport.set_scaling_3d_mode(Viewport.SCALING_3D_MODE_FSR2)
	scale_label.set_text(str(fsr["scale"])+"%")
	scale_name.set_text(fsr["label"])
	get_viewport().set_scaling_3d_scale(fsr["scale"]/100.0)

func _on_vsync_checkbox_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	if !toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func get_screens() -> void:
	var Screens: int = DisplayServer.get_screen_count()
	for s: int in Screens:
		screen_selector.add_item("Screen: " + str(s))

func _on_screen_selector_item_selected(index: int) -> void:
	var _window: Window = get_window()
	var mode: int = _window.get_mode()
	_window.set_mode(Window.MODE_WINDOWED)
	_window.set_current_screen(index)
	if mode == Window.MODE_FULLSCREEN:
		_window.set_mode(Window.MODE_FULLSCREEN)

func _on_button_pressed() -> void:
	Set_Resolution(Vector2i(int($HBoxContainer/Xvalue.text), int($HBoxContainer/Yvalue.text)))
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		_on_full_screen_check_box_toggled(DisplayServer.window_get_mode() != Window.MODE_MAXIMIZED)
