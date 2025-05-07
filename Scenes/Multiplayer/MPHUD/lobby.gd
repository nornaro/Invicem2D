extends Container

var latencies: Array
var server_select:PackedScene = preload("res://Scenes/Multiplayer/MPHUD/server_select.tscn")
var host_dir:String = "res://Scenes/Client/Join/"
var port:int = Global.start_port

func update() -> void:
	_on_update_timeout()

func _ready() -> void:
	add_to_group("Update")
	latencies.resize(5)
	var networks:Array = Global.RL.get_files_at(host_dir)
	for network:String in networks:
		var instance:Node = Node.new()
		instance.name = network.split(".")[0]
		instance.set_script(Global.RL.load(host_dir+network+"/join.gd"))
		add_child(instance)
		instance.set_process(true)
		instance.port = port
		instance.lobby()
		port += 1

func _on_update_timeout() -> void:
	var servers: Dictionary = Global.servers
	for server: String in servers.keys():
		var server_name: String = str(server)
		var child: Node
		if !get_node_or_null(server_name):
			var instance: Node = server_select.instantiate()
			instance.name = server_name
			add_child(instance)
		child = get_node(server_name)

		var latency: String = latency_calc()  # Forcefully convert int to string
		child.join_data = str(Global.servers[server].Join)
		child.get_node("Name").text = Global.servers[server].Name
		child.get_node("Name").tooltip_text += Global.servers[server].Network
		child.get_node("Code").text = Global.servers[server].UID
		child.get_node("Players").text = str(Global.servers[server].Players.size())
		child.get_node("Players").tooltip_text = str(Global.servers[server].Players)
		child.get_node("Latency").text = latency  # Guaranteed to be a string



	#update.start()

func latency_calc() -> String:
	var latency:int = 0
	return str(latency)
	#latencies.push_back(Time.get_ticks_msec()-Global.servers[server].LobbyLatency)
	#for l in latencies:
		#if l:
			#latency += l
	#if latencies:
		#latency /= latencies.size()
		#latencies.pop_front()
