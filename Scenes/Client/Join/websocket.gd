extends Node

@export var websocket_url = "wss://echo.websocket.org"
var socket = WebSocketPeer.new()

func _ready():
	var err = socket.connect_to_url(websocket_url)
	if err != OK:
		await get_tree().create_timer(2).timeout
		socket.send_text("Test packet")
		return
	print("Unable to connect")
	set_process(false)

func _process(_delta):
	socket.poll()
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			print("Got data from server: ", socket.get_packet().get_string_from_utf8())
	if state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		print("WebSocket closed with code: %d. Clean: %s" % [code, code != -1])
		set_process(false) # Stop processing.
	if state == WebSocketPeer.STATE_CLOSING:
		pass
