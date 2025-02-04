extends Button

@onready var round_timer = preload("res://Scenes/Timers/round_timer.tscn")
@onready var network = preload("res://Scenes/Multiplayer/Network/network.tscn")
var server: Node

func _ready() -> void:
	connect("pressed", _on_pressed)

func _on_pressed() -> void:
	var scene = load("res://Scenes/Server/server.tscn")
	server = scene.instantiate()
	server.name = "Server"
	server.add_to_group("Server")
	scene = load("res://Scenes/Server/console.tscn")
	var console = scene.instantiate()
	console.name = "Console"
	console.add_to_group("Console")
	get_tree().call_group("Main","add_child", server)
	get_tree().call_group("Main","add_child", console)

	match %NetworkType.current_tab:
		0:
			server.set_script(load("res://Scenes/Server/Host/enet.gd"))
		1:
			server.set_script(load("res://Scenes/Server/Host/steam.gd"))
		2:
			server.set_script(load("res://Scenes/Server/Host/nakama.gd"))
		3:
			server.set_script(load("res://Scenes/Server/Host/gds.gd"))
		4:
			server.set_script(load("res://Scenes/Server/Host/eos.gd"))
		5: 
			server.set_script(load("res://Scenes/Server/Host/jam.gd"))

	server.host()
	get_tree().call_group("MPHUD","hide")
	get_tree().call_group("Home","queue_free")
	#print(get_tree().get_nodes_in_group("Main"))
	get_tree().call_group("Main","add_child",round_timer.instantiate())
	var instance = network.instantiate()
	instance.set_script(load("res://Scenes/Multiplayer/Network/server.gd"))
	get_tree().call_group("Main","add_child",instance)
