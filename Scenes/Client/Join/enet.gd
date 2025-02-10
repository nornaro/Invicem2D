extends Node

var player: PackedScene = preload("res://Scenes/Client/2d_client.tscn")
var server: NetworkMgr = NetworkMgr.new()
var server_node: Node

var udp_server := UDPServer.new()
var broadcast_port = 4242
var udp_peers = []
var uid: String

func _ready() -> void:
	udp_server.listen(broadcast_port)

	
func join() -> void:
	server_node = get_tree().get_first_node_in_group("Server")
	var peer = ENetMultiplayerPeer.new()
	peer.create_client("",6666)
	multiplayer.multiplayer_peer = peer
	multiplayer.connected_to_server.connect(connected)
	multiplayer.server_disconnected.connect(disconnected)
	

@rpc("any_peer")
func remove_player(id):
	server_node.get_node_or_null(str(id)).queue_free()

func connected():
	add_player(multiplayer.get_unique_id())
	pass
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
	udp_server.poll() # Important!
	if udp_server.is_connection_available():
		var udp_peer: PacketPeerUDP = udp_server.take_connection()
		var udp_packet = JSON.parse_string(udp_peer.get_packet().get_string_from_utf8())
		udp_packet["PollPort"] = udp_peer.get_packet_port()
		udp_packet["IP"] = udp_peer.get_packet_ip()
		Global.servers[udp_packet.UID] = udp_packet
		#print("Received data: %s from %s:%s" % [,)
