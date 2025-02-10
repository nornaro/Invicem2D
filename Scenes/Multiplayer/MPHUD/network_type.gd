extends TabBar

func _ready() -> void:
	on_tab_changed(0)
	connect("tab_changed",on_tab_changed)
	
func on_tab_changed(tab: int) -> void:
	var server = get_tree().get_first_node_in_group("Server")
	match tab:
		0:
			server.set_script(Global.RL.load("res://Scenes/Client/Join/enet.gd"))
		1:
			server.set_script(Global.RL.load("res://Scenes/Client/Join/steam.gd"))
		2:
			server.set_script(Global.RL.load("res://Scenes/Client/Join/nakama.gd"))
		3:
			server.set_script(Global.RL.load("res://Scenes/Client/Join/gds.gd"))
		4:
			server.set_script(Global.RL.load("res://Scenes/Client/Join/eos.gd"))
		5: 
			server.set_script(Global.RL.load("res://Scenes/Client/Join/jam.gd"))
	server.set_process(true)
	server._ready()
