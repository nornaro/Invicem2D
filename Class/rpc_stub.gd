class_name RPCStub
extends Object

var _ws: WebSocketPeer

func _init(ws):
	_ws = ws

func doubled(val):
	return await _send("doubled", [val])

func hello():
	return await _send("hello", [])

func _send(func_name: String, args: Array):
	var packet = {
		"func": func_name,
		"args": args,
	}
	_ws.send_text(JSON.stringify(packet))
	
	while _ws.get_ready_state() == WebSocketPeer.STATE_OPEN:
		_ws.poll()
		if _ws.get_available_packet_count() <= 0:
			continue
		var resp = JSON.parse_string(_ws.get_packet().get_string_from_utf8())
		if resp.has("result"):
			return resp.result
	return null
