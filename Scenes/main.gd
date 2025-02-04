extends Camera2D

@onready var main_menu = preload("res://Scenes/MainMenu/home_screen.tscn")

func _ready() -> void:
	add_child(main_menu.instantiate())
 
