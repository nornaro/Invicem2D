extends Button

@onready var timer = preload("res://Scenes/Minions/minions.tscn")
@onready var network = preload("res://Scenes/Multiplayer/Network/network.tscn")

func _ready() -> void:
	connect("pressed", _on_pressed)

func _on_pressed() -> void:
	var server = get_tree().get_first_node_in_group("Server")
	server.join()
	get_tree().call_group("MPHUD","hide")
	get_tree().call_group("Home","queue_free")
	get_tree().call_group("Main","add_child",network.instantiate())
