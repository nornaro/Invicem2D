extends Node

var port: int
var server_node: Node
var search: bool = true
var udp_server := UDPServer.new()
var broadcast_port: int = 4242
var udp_peers: Array = []
var uid: String

func lobby() -> void:
	server_node = get_tree().get_first_node_in_group("Server")
	udp_server.listen(broadcast_port)
	set_process(true)

func join() -> void:
	server_node = get_tree().get_first_node_in_group("Server")
	server_node.player = Global.client
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	multiplayer.connected_to_server.connect(_connected)
	multiplayer.server_disconnected.connect(_disconnected)
	var join_data = Global.join_data.split(":")
	if IP.get_local_addresses().has(join_data[0]):
		join_data[0] = "127.0.0.1"
	peer.create_client(join_data[0],int(join_data[1]))
	multiplayer.multiplayer_peer = peer
	set_process(true)

func _connected() -> void:
	server_node.add_player(multiplayer.get_unique_id())

func _disconnected() -> void:
	push_warning("Connection lost")
	server_node.remove_player(multiplayer.get_unique_id())

func _input(event: InputEvent) -> void:
	if event.is_action("ui_accept"):
		server_node.my_relay_rpc.rpc_id(1, "My player name is: " + str(multiplayer.get_unique_id()))

func _process(_delta: float) -> void:
	if !search:
		return
	udp_server.poll() # Important!
	if udp_server.is_connection_available():
		var udp_peer: PacketPeerUDP = udp_server.take_connection()
		var packet: Dictionary = JSON.parse_string(udp_peer.get_packet().get_string_from_utf8())
		packet["PollPort"] = udp_peer.get_packet_port()
		packet["IP"] = udp_peer.get_packet_ip()
		packet["Join"] = str(packet["IP"])+":"+ str(int(packet["Port"]))
		Global.servers[packet.UID] = packet
