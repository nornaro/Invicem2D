extends Node

@onready var mphud:PackedScene = preload("res://Scenes/Multiplayer/MPHUD/mphud.tscn")

func _ready() -> void:
	get_parent().get_parent().connect("pressed", _on_pressed)

func _on_pressed() -> void:
	get_tree().get_first_node_in_group("Home").add_child(mphud.instantiate())
	get_tree().call_group("MPHUD","show")
