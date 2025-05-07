extends TabBar

var port: int
var networks_path: String = "res://Scenes/Multiplayer/Network/"

func _ready() -> void:
	port = Global.start_port
	clear_tabs()
	var networks: Array = Global.RL.get_directories_at(networks_path)
	for network: String in networks:
		add_tab("",Global.RL.load(networks_path+network+"/icon.webp"))
		set_tab_tooltip(tab_count - 1, network)
		var instance: Node = Node.new()
		instance.name = network
		instance.set_script(Global.RL.load(networks_path + network+"/join.gd"))
		get_tree().get_first_node_in_group("")
		var network_node: Node = get_tree().get_first_node_in_group("Network")
		if !network_node:
			network_node = Node.new()
		network_node.add_child(instance)
		instance.lobby()
		instance.port = port
		port += 1
		if network == "ENet":
			current_tab = (tab_count - 1)

	#on_tab_changed(0)
	#connect("tab_changed",on_tab_changed)
	#
#func on_tab_changed(_tab: int) -> void:
	#var server:Node = get_tree().get_first_node_in_group("Server")
	#var network:String = get_tab_tooltip(current_tab).to_lower()
	#server.set_script(Global.RL.load("res://Scenes/Client/Join/"+ network +".gd"))
	#server.set_process(true)
	#server.lobby()
