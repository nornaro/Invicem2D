extends TabBar

func _ready() -> void:
	on_tab_changed(0)
	connect("tab_changed",on_tab_changed)
	
func on_tab_changed(_tab: int) -> void:
	var server:Node = get_tree().get_first_node_in_group("Server")
	var network:String = get_tab_tooltip(current_tab).to_lower()
	server.set_script(Global.RL.load("res://Scenes/Client/Join/"+ network +".gd"))
	server.set_process(true)
	server.lobby()
