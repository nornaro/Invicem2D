extends Button

@onready var timer = preload("res://Scenes/Minions/minions.tscn")
@onready var network = preload("res://Scenes/Multiplayer/Network/network.tscn")

func _ready() -> void:
	connect("pressed", _on_pressed)

func _on_pressed() -> void:
	var server = Node.new()
	server.name = "Server"
	server.add_to_group("Server")
	get_tree().call_group("Main","add_child", server)
	
	match %NetworkType.current_tab:
		0:
			server.set_script(load("res://Scenes/Client/Join/enet.gd"))
		1:
			server.set_script(load("res://Scenes/Client/Join/steam.gd"))
		2:
			server.set_script(load("res://Scenes/Client/Join/nakama.gd"))
		3:
			server.set_script(load("res://Scenes/Client/Join/gds.gd"))
		4:
			server.set_script(load("res://Scenes/Client/Join/eos.gd"))
		5: 
			server.set_script(load("res://Scenes/Client/Join/jam.gd"))
			
	server.join()
	get_tree().call_group("MPHUD","hide")
	get_tree().call_group("Home","queue_free")
	get_tree().call_group("Main","add_child",network.instantiate())
