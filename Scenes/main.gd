extends Camera2D

@onready var main_menu: PackedScene = preload("res://Scenes/MainMenu/home_screen.tscn")
@onready var network_scene:PackedScene = preload("res://Scenes/Multiplayer/network.tscn")

func _ready() -> void:
	make_current()
	add_child(network_scene.instantiate())
	add_child(main_menu.instantiate())
 
