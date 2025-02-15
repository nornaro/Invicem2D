extends Node

@onready var client: PackedScene = preload("res://Scenes/Client/2d_client.tscn")
@onready var round_timer: PackedScene = preload("res://Scenes/Timers/round_timer.tscn")

func _ready() -> void:
	get_parent().get_parent().connect("pressed", _on_pressed)

func _on_pressed() -> void:
	Global.mp = false
	get_tree().call_group("Home","queue_free")
	get_tree().call_group("Main","add_child",round_timer.instantiate())
	dummy_server()
	get_tree().call_group("Server","add_child",client.instantiate())

func dummy_server() -> void:
	var ds: Node = Node.new()
	ds.name = "Server"
	ds.add_to_group("Server")
	get_tree().call_group("Main","add_child",ds)
