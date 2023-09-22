extends ProgressBar

@onready var Castle = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	max_value=Castle.Data["base_health"]
	self.add_theme_color_override("theme_override_style/fill",Color(1,0,0))

func update():
	value = Castle.Data["health"]
	var style_box = StyleBoxFlat.new()
	var percentage = value / max_value
	style_box.bg_color = colorpicker(percentage)
	add_theme_stylebox_override("fill", style_box)
	add_theme_stylebox_override("foreground", style_box)

func colorpicker(percentage):
	var rate
	if percentage <= 0.2:
		rate = percentage / 0.2
		return Color(rate, 0, 0, 0.8)
	if percentage <= 0.5:
		rate = (percentage - 0.2) / 0.3
		return Color(1, rate, 0, 0.8)
	if percentage <= 1:
		rate = (percentage - 0.5) / 0.5
		return Color(1 - rate, 1, 0, 0.8)
	rate = min((percentage - 1.0) / 9.0, 1.0)
	return Color(rate, 1, rate, 0.8)
