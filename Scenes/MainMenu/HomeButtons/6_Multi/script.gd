extends Node

@onready var network = preload("res://Scenes/Multiplayer/network.tscn")

	
func _main() -> void:
	get_tree().root.add_child(network)
