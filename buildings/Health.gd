extends ProgressBar

@onready var Castle = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	max_value=Castle.base_health
	self.add_theme_color_override("theme_override_style/fill",Color(1,0,0))

func update():
	value = Castle.health
	if value>max_value/2:
		modulate = Color(0,(value-max_value/2)/(max_value/2),(value-max_value/2)/(max_value/2),0.8)
	var gradient = Gradient.new()
	gradient.add_point(0.0, Color(0, 0, 0))
	gradient.add_point(0.1, Color(1, 0, 0))
	gradient.add_point(0.5, Color(0, 1, 1))
	gradient.add_point(1.0, Color(0, 1, 0))
	var style_box = StyleBoxTexture.new()
	style_box.texture = gradient
	self.add_theme_stylebox_override("foreground", style_box)
