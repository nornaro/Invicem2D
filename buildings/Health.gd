extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	max_value=$"../..".base_health
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.add_theme_color_override("theme_override_style/fill",Color(1,0,0))
#	modulate = Color(1,(value/max_value)*(value/max_value),0,1-(0.5-abs(value/max_value)/4))
#	bg_color=Color(1,0,0)
	value=$"../..".health
	if value>max_value/2:
		modulate = Color(0,(value-max_value/2)/(max_value/2),(value-max_value/2)/(max_value/2),0.8)
#	theme_override_style/fill
	var gradient = Gradient.new()
	gradient.add_point(0.0, Color(0, 0, 0))
	gradient.add_point(0.1, Color(1, 0, 0))
	gradient.add_point(0.5, Color(0, 1, 1))
	gradient.add_point(1.0, Color(0, 1, 0))

#	var gradient_texture = GradientTexture.new()
#	gradient_texture.gradient = gradient

	var style_box = StyleBoxTexture.new()
	style_box.texture = gradient

	self.add_theme_stylebox_override("foreground", style_box)
#"bg_color""bg_color""theme_override_styles/fill"
