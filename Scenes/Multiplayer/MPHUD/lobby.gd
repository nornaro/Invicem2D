extends GridContainer

var latencies: Array
var server_select = preload("res://Scenes/Multiplayer/MPHUD/server_select.tscn")

func _ready() -> void:
	latencies.resize(5)
	$"../Update".start()
	$"../Update".set_autostart(true)

func _on_update_timeout() -> void:
	var servers = Global.servers
	for server in servers.keys():
		var child: Node
		if !get_node_or_null(server):
			var instance = server_select.instantiate()
			instance.name = server
			add_child(instance)
		child = get_node(server)
		
		latencies.push_back(Time.get_ticks_msec()-Global.servers[server].LobbyLatency)
		var latency = 0
		for l in latencies:
			if l:
				latency += l
		latency /= latencies.size()
		latencies.pop_front()
		child.get_node("Name").text = Global.servers[server].LobbyName
		child.get_node("Code").text = Global.servers[server].UID
		child.get_node("Players").text = str(Global.servers[server].LobbyPlayers.size())
		child.get_node("Players").tooltip_text = str(Global.servers[server].LobbyPlayers)
		child.get_node("Latency").text = str(int(latency))
	$"../Update".start()
