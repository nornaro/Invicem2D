extends Node

var udp_peer: PacketPeerUDP = PacketPeerUDP.new()
var port: int = 4242

func host() -> void:
	set_process(true)

func _process(_delta: float) -> void:
	udp_peer.connect_to_host("255.255.255.255", 4242)
	var lobby: Dictionary = {
		"UID": Global.uid,
		"Name": "Test",
		"Game": Global.game,
		"Players": Global.clients,
		"Network": "ENet",
		"Port": 9001,
		"Latency": 0,
	}
	udp_peer.put_packet(JSON.stringify(lobby).to_utf8_buffer())
