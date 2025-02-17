extends Node

@onready var client: PackedScene = preload("res://Scenes/Multiplayer/2d_client.tscn")
@onready var round_timer: PackedScene = preload("res://Scenes/Timers/round_timer.tscn")

func _ready() -> void:
	get_parent().get_parent().connect("pressed", _on_pressed)

func _on_pressed() -> void:
	Global.mp = false
	get_tree().get_first_node_in_group("Home").set_process(true)
	get_tree().get_first_node_in_group("Main").add_child(round_timer.instantiate())
	get_tree().get_first_node_in_group("Server").add_child(client.instantiate())
	
#func dummy_server() -> void:
	#var ds: Node = Node.new()
	#ds.name = "Server"
	#ds.add_to_group("Server")
	#get_tree().call_group("Main","add_child",ds)
