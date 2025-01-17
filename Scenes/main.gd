extends Node

@onready var main_menu = preload("res://Scenes/MainMenu/home_screen.tscn") #A
@onready var network = preload("res://Scenes/Multiplayer/network.tscn") #A

func _ready() -> void:
	add_child(main_menu.instantiate())
	add_child(network.instantiate())
	$Network.
