extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	max_value=$"../..".hp

func hurt():
	self.add_theme_color_override("theme_override_style/fill",Color(1,0,0))
	modulate = Color(1,(value/max_value)*(value/max_value),0,0.75)
	value=$"../..".hp
