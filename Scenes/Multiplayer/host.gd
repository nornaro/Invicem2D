extends Button

@onready var round_timer:PackedScene = preload("res://Scenes/Timers/round_timer.tscn")
@onready var network:PackedScene = preload("res://Scenes/Multiplayer/Network/network.tscn")
var server: Node

func _ready() -> void:
	connect("pressed", _on_pressed)

func _on_pressed() -> void:
	var scene:PackedScene = Global.RL.load("res://Scenes/Server/server.tscn")
	server = scene.instantiate()
	server.name = "Server"
	server.add_to_group("Server")
	scene = Global.RL.load("res://Scenes/Server/console.tscn")
	var console:Node = scene.instantiate()
	console.name = "Console"
	console.add_to_group("Console")
	get_tree().call_group("Server","free")
	get_tree().call_group("Main","add_child", server)
	get_tree().call_group("Main","add_child", console)
	server.set_script(Global.RL.load("res://Scenes/Server/Host/"+%NetworkType.get_tab_tooltip(%NetworkType.current_tab).to_lower()+".gd"))
	server.set_process(true)
	server.host()
	get_tree().call_group("MPHUD","hide")
	get_tree().call_group("Home","queue_free")
	get_tree().call_group("Main","add_child",round_timer.instantiate())
	var instance:Node = network.instantiate()
	instance.set_script(Global.RL.load("res://Scenes/Multiplayer/Network/server.gd"))
	get_tree().call_group("Main","add_child",instance)
