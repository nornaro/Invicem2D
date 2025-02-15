extends GridContainer

var latencies: Array
var server_select:PackedScene = preload("res://Scenes/Multiplayer/MPHUD/server_select.tscn")

func _ready() -> void:
	latencies.resize(5)
	$"../Update".start()
	$"../Update".set_autostart(true)

func _on_update_timeout() -> void:
	var servers:Dictionary = Global.servers
	for server:String in servers.keys():
		var child: Node
		if !get_node_or_null(str(server)):
			var instance: Node = server_select.instantiate()
			instance.name = str(server)
			add_child(instance)
		child = get_node(str(server))
		var latency:int = latency_calc()
		child.join_data = Global.servers[server].Join
		child.get_node("Name").text = Global.servers[server].Name
		child.get_node("Code").text = Global.servers[server].UID
		child.get_node("Players").text = str(Global.servers[server].Players.size())
		child.get_node("Players").tooltip_text = str(Global.servers[server].Players)
		child.get_node("Latency").text = str(int(latency))
	$"../Update".start()

func latency_calc() -> int:
	var latency:int = 0
	return latency
	#latencies.push_back(Time.get_ticks_msec()-Global.servers[server].LobbyLatency)
	#for l in latencies:
		#if l:
			#latency += l
	#if latencies:
		#latency /= latencies.size()
		#latencies.pop_front()
	
