extends TextureButton


@onready var round_timer = preload("res://Scenes/Timers/round_timer.tscn") # s


func _ready() -> void:
	self.connect("pressed", _on_pressed)
	
func _on_pressed(index: int) -> void:
	get_parent().add_child(round_timer.instantiate())
