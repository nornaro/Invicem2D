extends Node


var player: PackedScene
var port: int = 9001
var server_node: Node
var peer: SteamMultiplayerPeer = SteamMultiplayerPeer.new()
var refresh:float = 1.0
var initialize_response: Dictionary
var status:int = 0

func lobby() -> void:
	OS.set_environment("SteamAppId", str(480))
	OS.set_environment("SteamGameId", str(480))
	initialize_response = Steam.steamInitEx()
	server_node = get_tree().get_first_node_in_group("Server")
	player = Global.client
	if initialize_response.status != status:
		status = initialize_response.status
		print_debug(initialize_response.verbal)
	if initialize_response.status:
		return
	set_process(true)
	Steam.lobby_match_list.connect(_fill_steam_lobby_menu)

func join() -> void:
	server_node = get_tree().get_current_scene().get_node("Server")
	server_node.player = Global.client
	print("Joining lobby %s" % Global.join_data)
	multiplayer.peer_connected.connect(_connected)
	multiplayer.peer_disconnected.connect(_disconnected)
	Steam.lobby_joined.connect(_on_lobby_joined.bind())
	Steam.joinLobby(int(109775243890626418))

func _on_lobby_joined(lobby_id: int, _permissions: int, _locked: bool, response: int) -> void:
	if response != 1:
		var FAIL_REASON: String
		match response: # Get the failure reason
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
		print(FAIL_REASON)
		return
	var id:int = Steam.getLobbyOwner(lobby_id)
	if id != Steam.getSteamID():
		print("Connecting client to socket...")
		connect_socket(id)
	
func connect_socket(steam_id: int) -> void:
	var error:int = peer.create_client(steam_id, 0)
	if error != OK:
		print("Error creating client: %s" % str(error))
		return
	print("Connecting peer to host...")
	multiplayer.set_multiplayer_peer(peer)

func list_lobbies() -> void:
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	# NOTE: If you are using the test app id, you will need to apply a filter on your game name
	# Otherwise, it may not show up in the lobby list of your clients
	Steam.addRequestLobbyListStringFilter("name", Global.game, Steam.LOBBY_COMPARISON_EQUAL)
	Steam.requestLobbyList()

func _physics_process(delta:float) -> void:
	Steam.run_callbacks()
	refresh -= delta
	if refresh > 0:
		return
	refresh = 1.0
	#list_lobbies()
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
		packet["Network"] = Steam.getLobbyData(l, "Steam")
		packet["Players"] = players
		packet["Id"] = multiplayer.get_unique_id()
		packet["Name"] = Steam.getLobbyData(l, "name")
		packet["Latency"] = 0
		Global.servers[str(l)] = packet

func _connected(id:int) -> void:
	server_node.add_player(id)
	
func _disconnected(id:int) -> void:
	server_node.remove_player(id)
