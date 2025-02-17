extends Button

@onready var timer:PackedScene = preload("res://Scenes/Minions/minions.tscn")

func _ready() -> void:
	connect("pressed", _on_pressed)

func _on_pressed() -> void:
	#var server:Node = get_tree().get_first_node_in_group("Server")
	var currect_tab:String = %NetworkType.get_tab_tooltip(%NetworkType.current_tab)
	var network:Node = get_tree().get_first_node_in_group("Network").get_node(currect_tab)
	
	network.join()
	get_tree().call_group("MPHUD","hide")
	get_tree().call_group("Home","set_process",true)

"""
func _on_pressed_old() -> void:
	var server:Node = get_tree().get_first_node_in_group("Server")
	server.join()
	get_tree().call_group("MPHUD","hide")
	get_tree().call_group("Home","set_process",true)

func _ready() -> void:
	connect("pressed", _on_pressed)

func _on_pressed() -> void:
	get_tree().call_group("Server","free")
	#var minion_timer_scene:PackedScene = Global.RL.load("res://Scenes/Minions/minions.tscn")
	var network_scene:PackedScene = Global.RL.load("res://Scenes/Multiplayer/Network/network.tscn")
	
	var server:Node = get_tree().get_first_node_in_group("Server")
		
	get_tree().call_group("MPHUD","hide")
	get_tree().call_group("Home","set_process",true)
	
	#var minion_timer: Node = minion_timer_scene.instantiate()
	#minion_timer.name = "Network"
	
	var network: Node = network_scene.instantiate()
	network.name = "Network"
	network.set_script(Global.RL.load("res://Scenes/Multiplayer/Network/client.gd"))
	
	get_tree().call_group("Main","add_child", network)
	#get_tree().call_group("Main","add_child", minion_timer)
"""
