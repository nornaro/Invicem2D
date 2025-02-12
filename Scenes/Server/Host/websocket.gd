extends Node

const PORT = 9080
var _server = WebSocketPeer.new()

func _ready():
	_server.client_connected.connect(_connected)
	_server.client_disconnected.connect(_disconnected)
	_server.client_close_request.connect(_close_request)
	_server.data_received.connect(_on_data)
	var err = _server.listen(PORT)
	if err != OK:
		print("Unable to start server")
		set_process(false)

func _connected(id, proto):
	print("Client %d connected with protocol: %s" % [id, proto])

func _close_request(id, code, reason):
	print("Client %d disconnecting with code: %d, reason: %s" % [id, code, reason])

func _disconnected(id, was_clean = false):
	print("Client %d disconnected, clean: %s" % [id, str(was_clean)])

func _on_data(id):
	var pkt = _server.get_peer(id).get_packet()
	print("Got data from client %d: %s ... echoing" % [id, pkt.get_string_from_utf8()])
	_server.get_peer(id).put_packet(pkt)

func _process(delta):
	_server.poll()

func host():
	pass
