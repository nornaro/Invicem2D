extends Node

var port: int = 8890
var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
var server_node: Node
var host: String = ""
#var adress: String = ""
var game_id: String = ""
var _current_host_oid: String = ""

func lobby() -> void:
	pass

func join() -> void:
	server_node = get_tree().get_first_node_in_group("Server")
	server_node.player = Global.client
	_current_host_oid = game_id
	multiplayer.connected_to_server.connect(_connected)
	multiplayer.server_disconnected.connect(_disconnected)
	Noray.on_connect_nat.connect(_handle_nat_connect)
	Noray.on_connect_relay.connect(_handle_relay_connect)
	await _register_with_noray()
	Noray.connect_nat(game_id)
	set_process(true)

func _register_with_noray() -> int:
	var err:int = await Noray.connect_to_host(host,port)
	if err != OK:
		push_warning("Noray registration failed: %s" % err)
		return err
	await Noray.register_remote()
	return 0

func _handle_nat_connect() -> Error:
	var err:int = await _connect_to_host()
	if err != OK:
		push_warning("NAT failed, falling back to relay")
		Noray.connect_relay(_current_host_oid)
		return OK
	print_debug("NAT successful")
	return err

func _handle_relay_connect() -> Error:
	return await _connect_to_host()

func _connect_to_host() -> Error:
	var udp := PacketPeerUDP.new()
	udp.bind(Noray.local_port)
	udp.set_dest_address(host, port)
	var err:int = await PacketHandshake.over_packet_peer(udp, 8)
	udp.close()
	if err != OK:
		push_warning("Handshake failed: %s" % err)
		return err
	err = peer.create_client(host, port, 0, 0, 0, Noray.local_port)
	if err != OK:
		push_warning("Client connect failed: %s" % err)
		return err
	multiplayer.multiplayer_peer = peer
	return OK

func _connected() -> void:
	print_debug("Successfully connected to server!")
	server_node.add_player(multiplayer.get_unique_id())

func _disconnected() -> void:
	push_warning("Connection lost")
	server_node.remove_player(multiplayer.get_unique_id())

func _input(event: InputEvent) -> void:
	if event.is_action("ui_accept"):
		server_node.my_relay_rpc.rpc_id(1, "My player name is: " + str(multiplayer.get_unique_id()))
