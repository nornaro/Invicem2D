extends Node

@export var websocket_url:String = "wss://echo.websocket.org"
var socket:WebSocketPeer = WebSocketPeer.new()
var port: int
var player:PackedScene

func _ready() -> void:
	player = Global.client
	var err:int = socket.connect_to_url(websocket_url)
	if err != OK:
		socket.send_text("Test packet")
		return
	push_warning("Unable to connect")
	set_process(false)

func _process(_delta:float) -> void:
	socket.poll()
	var state:int = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			push_warning("Got data from server: ", socket.get_packet().get_string_from_utf8())
	if state == WebSocketPeer.STATE_CLOSED:
		var code:int = socket.get_close_code()
		push_warning("WebSocket closed with code: %d. Clean: %s" % [code, code != -1])
		set_process(false) # Stop processing.
	if state == WebSocketPeer.STATE_CLOSING:
		pass
		
func lobby() -> void:
	pass

func join() -> void:
	pass
