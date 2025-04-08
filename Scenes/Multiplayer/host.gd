extends Button

func _ready() -> void:
	connect("pressed", _on_pressed)

func _on_pressed() -> void:
	get_tree().call_group("Server","free")
	
	var server_scene:PackedScene = Global.RL.load("res://Scenes/Multiplayer/server.tscn")
	var server: Node = server_scene.instantiate()
	server.name = "Server"
	server.add_to_group("Server")
	get_tree().call_group("Main","add_child", server)

	var round_timer:PackedScene = Global.RL.load("res://Scenes/Timers/round_timer.tscn")
	get_tree().call_group("Main","add_child",round_timer.instantiate())
	
	var networks_path:String = "res://Scenes/Multiplayer/Network/"
	var network_node: Node = get_tree().get_first_node_in_group("Network")
	#network_node.set_script(Global.RL.load("res://Scenes/Multiplayer/server.gd"))
	var networks: Array = Global.RL.get_directories_at(networks_path)
	var port:int = Global.start_port
	for network:String in networks:
		Global.network_ports[network] = port
		var n:Node = network_node.get_node(network)
		n.set_script(Global.RL.load(networks_path+network+"/host.gd"))
		n.port = port
		port += 1
		n.host()

	if Global.dedicated:
		return
		
	get_tree().call_group("MPHUD","queue_free",)
	get_tree().call_group("Home","set_process",true)
	var console_scene:PackedScene = Global.RL.load("res://Scenes/Multiplayer/console.tscn")
	var console:Node = console_scene.instantiate()
	console.name = "Console"
	console.add_to_group("Console")
	get_tree().call_group("Main","add_child", console)
