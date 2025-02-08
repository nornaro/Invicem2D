extends TextureButton

@onready var client_2d = preload("res://Scenes/Client/2d_client.tscn")


func _ready() -> void:
	self.connect("pressed", _on_pressed)
	
func _on_pressed(index: int) -> void:
	get_parent().add_child(client_2d.instantiate())
