extends Node

var player: PackedScene
var multiplayer_peer:SteamMultiplayerPeer = SteamMultiplayerPeer.new()
var server_node: Node

#var udp_server := UDPServer.new()
#var broadcast_port = 4242
#var udp_peers = []
var port:int
var uid: String
var refresh:float = 1.0
var search:bool = true
var is_owned: bool = false
var steam_app_id: int = 480
var steam_id: int = 0
var steam_username: String = ""
var initialize_response: Dictionary
var status:int = 0
const LOBBY_NAME = "InvicemTD"

func lobby() -> void:
	server_node = get_tree().get_first_node_in_group("Server")
	player = Global.client
	OS.set_environment("SteamAppId", str(steam_app_id))
	OS.set_environment("SteamGameId", str(steam_app_id))
	initialize_response = Steam.steamInitEx()
	if initialize_response.status != status:
		status = initialize_response.status
		print_debug(initialize_response.verbal)
	if initialize_response.status:
		return
	set_process(true)
	Steam.lobby_match_list.connect(_fill_steam_lobby_menu)

func join() -> void:
	Steam.lobby_joined.connect(_on_lobby_joined.bind())
	Steam.steam_server_connected.connect(_connected)
	Steam.steam_server_disconnected.connect(_disconnected)
	var join_data:int = int(Global.join_data)
	Steam.joinLobby(join_data)
	#Steam.connectP2P(join_data, port, {})
	#Steam.connectByIPAddress("192.168.1.141:"+str(port), {})
	#search = false
	set_process(false)

func _on_lobby_joined(steam_lobby: int, _permissions: int, _locked: bool, response: int) -> void:
	if response != 1:
		# Get the failure reason
		var FAIL_REASON: String
		match response:
			2:  FAIL_REASON = "This lobby no longer exists."
			3:  FAIL_REASON = "You don't have permission to join this lobby."
			4:  FAIL_REASON = "The lobby is now full."
			5:  FAIL_REASON = "Uh... something unexpected happened!"
			6:  FAIL_REASON = "You are banned from this lobby."
			7:  FAIL_REASON = "You cannot join due to having a limited account."
			8:  FAIL_REASON = "This lobby is locked or disabled."
			9:  FAIL_REASON = "This lobby is community locked."
			10: FAIL_REASON = "A user in the lobby has blocked you from joining."
			11: FAIL_REASON = "A user you have blocked is in the lobby."
		push_error(FAIL_REASON)
		return
	var id:int = Steam.getLobbyOwner(steam_lobby)
	if id != Steam.getSteamID():
		push_warning("Connecting client to socket...")
		connect_socket(id)

func connect_socket(_steam_id: int) -> void:
	multiplayer_peer.peer_connected.connect(_connected)
	var error:int = multiplayer_peer.create_client(steam_id, port)
	multiplayer.multiplayer_peer = multiplayer_peer
	multiplayer.connected_to_server.connect(_connected)
	multiplayer.server_disconnected.connect(_disconnected)
	if error != OK:
		push_error("Error creating client: %s" % str(error))
	print_rich("Connecting peer to host...")
	multiplayer.set_multiplayer_peer(multiplayer_peer)

@rpc("any_peer")
func remove_player(id:int) -> void:
	server_node.get_node_or_null(str(id)).queue_free()

func _connected() -> void:
	add_player(multiplayer.get_unique_id())
	pass
	#add_player.rpc_id(1, multiplayer.get_unique_id())

func _disconnected() -> void:
	push_warning("Connection lost")
	remove_player.rpc_id(multiplayer.get_unique_id())

@rpc("any_peer")
func add_player(id:int) -> void:
	var player_instance:Node = player.instantiate()
	player_instance.name = str(id)
	Global.id = id
	server_node.add_child(player_instance)
###unprocess
func _physics_process(delta:float) -> void:
	if !search:
		return
	refresh -= delta
	if refresh > 0:
		return
	refresh = 1.0
	Steam.run_callbacks()
	Steam.requestLobbyList()
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.addRequestLobbyListStringFilter("game", Global.game, Steam.LOBBY_COMPARISON_EQUAL)

func _fill_steam_lobby_menu(lobbies: Array) -> void:
	var packet: Dictionary
	for l:int in lobbies:
		if Global.server_id != "" and not (
				str(l).contains(Global.server_id) or 
				str(Steam.getLobbyData(l, "game")).contains(Global.server_id)):
			return
		if Steam.getLobbyData(l, "game") != Global.game:
			return
		var players:Array = []
		for i: int in range(Steam.getNumLobbyMembers(l)):
			players.append( Steam.getPlayerNickname(Steam.getLobbyMemberByIndex(l,i)))

		#var details:Dictionary = Steam.getServerDetails(l,0)
		packet["Game"] = Steam.getLobbyData(l, "game")
		packet["Join"] = str(l)
		packet["Code"] = Steam.getLobbyData(l, "UID")
		packet["UID"] = Steam.getLobbyData(l, "UID")
		packet["Players"] = players
		packet["Id"] = multiplayer.get_unique_id()
		packet["Name"] = Steam.getLobbyData(l, "name")
		packet["Latency"] = 0
		Global.servers[str(l)] = packet

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

##Steam
#var player: PackedScene = preload("res://Scenes/Client/2d_client.tscn")
#var server_node: Node
#
#func join() -> void:
	#server_node = get_tree().get_first_node_in_group("Server")
	#var peer = SteamMultiplayerPeer.new()
	#peer.create_client(480,port)
	#multiplayer.multiplayer_peer = peer
	#multiplayer.connected_to_server.connect(connected)
	#multiplayer.server_disconnected.connect(disconnected)
	#
#func _steam_join_pressed() -> void:
	#Global.peer = SteamMultiplayerPeer.new()
	#Global.peer.create_client(480, port)
		#
#func _steam_lobby_pressed() -> void:
	#Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_CLOSE)
	#Steam.lobby_match_list.connect(fill_steam_lobby_menu)
	#Steam.addRequestLobbyListStringFilter("game", GAME_ID, Steam.LOBBY_COMPARISON_EQUAL)
	#Steam.requestLobbyList()
#
#func fill_steam_lobby_menu(lobbies: Array) -> void:
	#var lobby = {}
	#for child in %Lobby.get_children():
		#lobby[child.name] = child
	#for l in lobbies:
		#if %Search.text != "" and not (
				#str(l).contains(%Search.text) or 
				#str(Steam.getLobbyData(lobby, "name")).contains(%Search.text)):
			#return
		#lobby["Lobbyinfo"].add_item(" " + Steam.getLobbyData(lobby, "info"))
		#lobby["LobbyName"].add_item(" " + Steam.getLobbyData(lobby, "name"))
		#lobby["LobbyPlayers"].add_item(" " + str(Steam.getNumLobbyMembers(lobby)), null, false)
		#lobby["LobbyId"].add_item(str(lobby), null, false)
#
#func connected():
	#add_player(multiplayer.get_unique_id())
	#pass
	##add_player.rpc_id(1, multiplayer.get_unique_id())
#
#func disconnected():
	#push_warning("Connection lost")
	#remove_player.rpc_id(multiplayer.get_unique_id())
	#
#@rpc("any_peer")
#func add_player(id):
	#var player_instance = player.instantiate()
	#player_instance.name = str(id)
	#server_node.add_child(player_instance)
	#
#@rpc("any_peer")
#func remove_player(id):
	#server_node.get_node_or_null(str(id)).queue_free()
