extends Node

# The URL we will connect to.
var websocket_url = "ws://localhost:9080"
var socket := WebSocketPeer.new()


func log_message(message):
	var time = "[color=#aaaaaa] %s [/color]" % Time.get_time_string_from_system()
	%TextClient.text += time + message + "\n"


func join():
	if socket.connect_to_url(websocket_url) != OK:
		log_message("Unable to connect.")
	set_process(true)


func _process(_delta):
	socket.poll()

	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		return
	if socket.get_available_packet_count():
		log_message(socket.get_packet().get_string_from_ascii())


func _exit_tree():
	socket.close()


func _on_button_ping_pressed():
	socket.send_text("Ping")


"""
var player: PackedScene = preload("res://Scenes/Client/2d_client.tscn")
var server_node: Node

var websocket_client := WebSocketMultiplayerPeer.new()
var uid: String

func join() -> void:
	server_node = get_tree().get_first_node_in_group("Server")
	print(websocket_client.get_signal_list())
	websocket_client.connect("peer_connected", connected)
	websocket_client.connect("peer_disconnected", disconnected)
	#websocket_client.connect("data_received", _on_data_received)
	var err = websocket_client.create_client("ws://localhost:6666")
	if err != OK:
		push_error("Failed to connect to WebSocket server: %s" % err)

@rpc("any_peer")
func remove_player(id):
	server_node.get_node_or_null(str(id)).queue_free()

func connected(protocol: String = "") -> void:
	print("Connected to server with protocol: %s" % protocol)
	add_player(multiplayer.get_unique_id())

func disconnected(code: int = 0, reason: String = "", was_clean: bool = false) -> void:
	push_warning("Connection lost: %d - %s" % [code, reason])
	remove_player.rpc_id(multiplayer.get_unique_id())

@rpc("any_peer")
func add_player(id):
	var player_instance = player.instantiate()
	player_instance.name = str(id)
	server_node.add_child(player_instance)

@rpc("any_peer", "call_remote", "reliable")
func my_relay_rpc(_data: String):
	pass

func _input(event: InputEvent) -> void:
	if event.is_action("ui_accept"):
		var response = "My player name is: " + str(multiplayer.get_unique_id())
		my_relay_rpc.rpc_id(1, response)

func _on_data_received():
	var data = websocket_client.get_peer(1).get_packet().get_string_from_utf8()
	print("Data received: %s" % data)

func _process(_delta):
	websocket_client.poll()
	
func lobby():
	pass

"""
