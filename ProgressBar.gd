extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	max_value=$"../..".hp
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.add_theme_color_override("theme_override_style/fill",Color(1,0,0))
	modulate = Color(1,(value/max_value)*(value/max_value),0,0.75)
#	bg_color=Color(1,0,0)
	value=$"../..".hp
#	theme_override_style/fill
	pass
#"bg_color""bg_color""theme_override_styles/fill"
