extends Node

var player: PackedScene = preload("res://Scenes/Client/2d_client.tscn")
var server_node: Node
var search = true
var udp_server := UDPServer.new()
var broadcast_port = 4242
var udp_peers = []
var uid: String

func lobby() -> void:
	udp_server.listen(broadcast_port)
	set_process(true)

	
func join() -> void:
	server_node = get_tree().get_first_node_in_group("Server")
	var peer = ENetMultiplayerPeer.new()
	var join_data
	#if !Global.join_data:
		##peer.create_client("",6666)
		#peer.create_client(join_data[0],join_data[1])
	if !join_data:
		return
	if Global.join_data:
		join_data = Global.join_data.split(":")
		var _err = peer.create_client(str(join_data[0]),int(join_data[1]))

	multiplayer.multiplayer_peer = peer
	multiplayer.connected_to_server.connect(connected)
	multiplayer.server_disconnected.connect(disconnected)
	search = false

@rpc("any_peer")
func remove_player(id):
	server_node.get_node_or_null(str(id)).queue_free()

func connected():
	add_player(multiplayer.get_unique_id())
	#add_player.rpc_id(1, multiplayer.get_unique_id())

func disconnected():
	push_warning("Connection lost")
	remove_player.rpc_id(multiplayer.get_unique_id())

@rpc("any_peer")
func add_player(id):
	var player_instance = player.instantiate()
	player_instance.name = str(id)
	server_node.add_child(player_instance)

# rpc declaration must match server script, but definition can be different.
@rpc("any_peer", "call_remote", "reliable")
func my_relay_rpc(_data: String):
	pass

func _input(event: InputEvent) -> void:
	if event.is_action("ui_accept"):
		var response = "My player name is: " + str(multiplayer.get_unique_id())
		my_relay_rpc.rpc_id(1, response)

func _process(_delta):
	if !search:
		return
	udp_server.poll() # Important!
	if udp_server.is_connection_available():
		var udp_peer: PacketPeerUDP = udp_server.take_connection()
		var packet = JSON.parse_string(udp_peer.get_packet().get_string_from_utf8())
		packet["PollPort"] = udp_peer.get_packet_port()
		packet["IP"] = udp_peer.get_packet_ip()
		packet["Join"] = str(packet["IP"])+":"+ str(int(packet["Port"]))
		Global.servers[packet.UID] = packet
