extends Node

var udp_server: UDPServer = UDPServer.new()
var port: int = 4242
var server_node: Node

func lobby() -> void:
	udp_server.listen(4242)
	set_process(true)

func join() -> void:
	pass

func ready() -> void:
	udp_server.listen(4242)

func _process(_delta: float) -> void:
	print(name)
	udp_server.poll() # Important!
	if udp_server.is_connection_available():
		var udp_peer: PacketPeerUDP = udp_server.take_connection()
		var packet: Dictionary = JSON.parse_string(udp_peer.get_packet().get_string_from_utf8())
		packet["PollPort"] = udp_peer.get_packet_port()
		packet["IP"] = udp_peer.get_packet_ip()
		packet["Join"] = str(packet["IP"])+":"+ str(int(packet["Port"]))
		Global.servers[packet.UID] = packet
