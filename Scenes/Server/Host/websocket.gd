extends Node


var player: PackedScene = preload("res://Scenes/Server/client.tscn")
var port: int = 6666
var server_node: Node
var tcp_server := TCPServer.new()
var socket := WebSocketPeer.new()

func host() -> void:
	if tcp_server.listen(port) != OK:
		log_message("Unable to start server.")
		set_process(false)
	server_node = get_tree().get_first_node_in_group("Server")
	set_process(true)

func log_message(message):
	var time = "[color=#aaaaaa] %s [/color]" % Time.get_time_string_from_system()
	%TextServer.text += time + message + "\n"

func _process(_delta):
	if tcp_server.is_connection_available():
		var conn: StreamPeerTCP = tcp_server.take_connection()
		assert(conn != null)
		socket.accept_stream(conn)
		return

	socket.poll()

	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		return
	if socket.get_available_packet_count():
		log_message(socket.get_packet().get_string_from_ascii())


func _exit_tree():
	socket.close()
	tcp_server.stop()


func _on_button_pong_pressed():
	socket.send_text("Pong")


"""
var player: PackedScene = preload("res://Scenes/Server/client.tscn")
var port: int = 6666
var server_node: Node

var websocket_server := WebSocketMultiplayerPeer.new()
var uid: String

func host() -> void:
	server_node = get_tree().get_first_node_in_group("Server")
	var err = websocket_server.create_server(port)
	if err != OK:
		push_error("Failed to start WebSocket server: %s" % err)
	websocket_server.connect("peer_connected", _on_client_connected)
	websocket_server.connect("peer_disconnected", _on_client_disconnected)
	#websocket_server.connect("data_received", _on_data_received)
	print("Server is running on port: %d" % port)
	set_process(true)

@rpc("any_peer", "call_remote", "reliable")
func my_relay_rpc(data: String):
	print_debug(data)

@rpc("any_peer")
func add_player(id):
	if server_node.get_node_or_null(str(id)):
		return
	var player_instance = player.instantiate()
	player_instance.name = str(id)
	server_node.add_child(player_instance)
	Global.clients.append(id)
	Global.clienthp[id] = 100

@rpc("any_peer")
func remove_player(id):
	if server_node.get_node(str(id)):
		server_node.get_node(str(id)).queue_free()
		Global.clients.erase(id)

func _on_client_connected(id: int):
	print("Client connected: %d" % id)
	add_player(id)

func _on_client_disconnected(id: int, was_clean: bool):
	print("Client disconnected: %d" % id)
	remove_player(id)

func _on_data_received(id: int):
	var data = websocket_server.get_peer(id).get_packet().get_string_from_utf8()
	print("Data received from client %d: %s" % [id, data])

func _process(delta: float) -> void:
	# Handle incoming discovery requests
	var lobby = {
		"UID": uid,
		"Port": port,
		"LobbyName": "WebSocketTest",
		"LobbyPlayers": Global.clients,
		"LobbyId": multiplayer.get_unique_id(),
		"LobbyLatency": Time.get_ticks_msec(),
	}
	websocket_server.put_packet(JSON.stringify(lobby).to_utf8_buffer())
"""
