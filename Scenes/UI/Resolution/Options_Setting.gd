extends VBoxContainer

@onready var resolution_option_button:Node = $Resolution_OptionButton
@onready var full_screen_check_box:Node = $FullScreen_CheckBox
@onready var scale_label:Node = $ScaleBox/ScaleLabel
@onready var scale_slider:Node = $ScaleBox/ScaleSlider
@onready var fsr_options:Node = $FSROptions
@onready var vsync_checkbox:Node = $vsync_checkbox
@onready var screen_selector:Node = $Screen_Selector


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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Add_Resolutions()
	Check_Variables()
	Get_Screens()

func Check_Variables() -> void:
	var _window:Window = get_window()
	var mode:int = _window.get_mode()
	
	if mode == Window.MODE_FULLSCREEN:
		resolution_option_button.set_disabled(true)
		full_screen_check_box.set_pressed_no_signal(true)
		
	if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED:
		vsync_checkbox.set_pressed_no_signal(true)

func Set_Resolution_Text() -> void:
	var Resolution_Text:String = str(get_window().get_size().x)+"x"+str(get_window().get_size().y)
	resolution_option_button.set_text(Resolution_Text)
	
	scale_slider.set_value_no_signal(100.00)
	_on_scale_slider_value_changed(100.00)
	
func Add_Resolutions() -> void:
	var Current_Resolution:Vector2i = get_window().get_size()
	var ID = 0
	for r in Resolutions.keys():
		resolution_option_button.add_item(r)
		if Resolutions[r] == Current_Resolution:
			resolution_option_button.select(ID)
		ID += 1

func _on_option_button_item_selected(index:int) -> void:
	var ID:String = resolution_option_button.get_item_text(index)
	Set_Resolution(Resolutions[ID])
	
func Set_Resolution(res:Vector2i) -> void:
	get_window().set_size(res)
	Set_Resolution_Text()
	Centre_Window()

func Centre_Window() -> void:
	var Centre_Screen:Vector2 = DisplayServer.screen_get_position()+DisplayServer.screen_get_size()/2
	var Window_Size:Vector2 = get_window().get_size_with_decorations()
	get_window().set_position(Centre_Screen-Window_Size/2)

func _on_full_screen_check_box_toggled(toggled_on:bool) -> void:
	resolution_option_button.set_disabled(toggled_on)
	if toggled_on:
		get_window().set_mode(Window.MODE_FULLSCREEN)
	if !toggled_on:
		get_window().set_mode(Window.MODE_WINDOWED)
		Centre_Window()
		
	get_tree().create_timer(.05).timeout.connect(Set_Resolution_Text)

func _on_scale_slider_value_changed(value:float) -> void:
	var Resolution_Scale:float = value/100.00
	print_rich(value)
	
	scale_label.set_text(str(value)+"%")
	get_viewport().set_scaling_3d_scale(Resolution_Scale)
	
func _on_scaler_item_selected(index:int) -> void:
	var _viewport:Viewport = get_viewport()
	
	match index:
		1:
			_viewport.set_scaling_3d_mode(Viewport.SCALING_3D_MODE_BILINEAR)
			scale_slider.set_editable(true)
			fsr_options.hide()
		2:
			_viewport.set_scaling_3d_mode(Viewport.SCALING_3D_MODE_FSR2)
			scale_slider.set_editable(false)
			fsr_options.show()
	
func _on_fsr_options_item_selected(index:int) -> void:
	match index:
		1:
			_on_scale_slider_value_changed(50.00)
		2:
			_on_scale_slider_value_changed(59.00)
		3:
			_on_scale_slider_value_changed(67.00)
		4:
			_on_scale_slider_value_changed(77.00)

func _on_vsync_checkbox_toggled(toggled_on:bool) -> void:
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	if !toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func Get_Screens() -> void:
	var Screens:int = DisplayServer.get_screen_count()
	
	for s:int in Screens:
		screen_selector.add_item("Screen: "+str(s))

func _on_screen_selector_item_selected(index:int) -> void:
	var _window:Window = get_window()
	var mode:int = _window.get_mode()
	_window.set_mode(Window.MODE_WINDOWED)
	_window.set_current_screen(index)
	
	if mode == Window.MODE_FULLSCREEN:
		_window.set_mode(Window.MODE_FULLSCREEN)

func _on_button_pressed() -> void:
	Set_Resolution(Vector2i(int($HBoxContainer/Xvalue.text),int($HBoxContainer/Yvalue.text)))
