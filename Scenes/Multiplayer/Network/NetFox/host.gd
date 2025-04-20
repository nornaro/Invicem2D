extends Node

#signal network_server_disconnected

var port:int = 8890
var host_ip: String = "tomfol.io"
var host_port: int = -1
var game_id: String = ""
var local_port:int = Noray.local_port

func host() -> int:
	# Connect to noray
	var err = OK
	var address:String = host_ip
	err = await Noray.connect_to_host(address)
	
	if err != OK:
		print("Failed to connect to Noray: %s" % error_string(err))
		return err
	
	# Get IDs
	Noray.register_host()
	await Noray.on_pid
	
	# Register remote address
	err = await Noray.register_remote()
	if err != OK:
		print("Failed to register remote address: %s" % error_string(err))
		return err
	
	# Our local port is a remote port to Noray, hence the weird naming
	print("Registered local port: %d" % Noray.local_port)
	if Noray.local_port <= 0:
		return ERR_UNCONFIGURED

	print("Starting host on port %s" % port)
	
	var peer:ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	err = peer.create_server(port)
	if err != OK:
		print("Failed to listen on port %s: %s" % [port, error_string(err)])
		return err

	get_tree().get_multiplayer().multiplayer_peer = peer
	print("Listening on port %s" % port)
	
	# Wait for server to start
	while peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTING:
		await get_tree().process_frame
	
	if peer.get_connection_status() != MultiplayerPeer.CONNECTION_CONNECTED:
		OS.alert("Failed to start server!")
		return FAILED
	
	get_tree().get_multiplayer().server_relay = true

	#NetworkTime.start()

	return 0

func _ready() -> void:
	Noray.on_connect_nat.connect(_handle_noray_client_connect)
	Noray.on_connect_relay.connect(_handle_noray_client_connect)

func _handle_noray_client_connect() -> Error:
	print_rich("Noray host handle connect: %s:%s" % [host_ip, port])
	var peer:ENetMultiplayerPeer = multiplayer.multiplayer_peer as ENetMultiplayerPeer
	var err:int = await PacketHandshake.over_enet(peer.host, host_ip, port)
	
	if err != OK:
		print_rich("Noray packet handshake failed %s" % err)
		return err
	
	return OK
