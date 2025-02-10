extends Node

const GAME_ID = "xcNhLTRbBH"
var player: PackedScene = preload("res://Scenes/Client/2d_client.tscn")
var server: NetworkMgr = NetworkMgr.new()
var server_node: Node

func join() -> void:
	server_node = get_tree().get_first_node_in_group("Server")
	var peer = SteamMultiplayerPeer.new()
	peer.create_client(480,6666)
	multiplayer.multiplayer_peer = peer
	multiplayer.connected_to_server.connect(connected)
	multiplayer.server_disconnected.connect(disconnected)
	
func _steam_join_pressed() -> void:
	Global.peer = SteamMultiplayerPeer.new()
	Global.peer.create_client(480, 6666)
		
func _steam_lobby_pressed() -> void:
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_CLOSE)
	Steam.lobby_match_list.connect(fill_steam_lobby_menu)
	Steam.addRequestLobbyListStringFilter("game", GAME_ID, Steam.LOBBY_COMPARISON_EQUAL)
	Steam.requestLobbyList()

func fill_steam_lobby_menu(lobbies: Array) -> void:
	print(lobbies)
	var lobby = {}
	for child in %Lobby.get_children():
		lobby[child.name] = child
	for l in lobbies:
		if %Search.text != "" and not (
				str(l).contains(%Search.text) or 
				str(Steam.getLobbyData(lobby, "name")).contains(%Search.text)):
			return
		lobby["Lobbyinfo"].add_item(" " + Steam.getLobbyData(lobby, "info"))
		lobby["LobbyName"].add_item(" " + Steam.getLobbyData(lobby, "name"))
		lobby["LobbyPlayers"].add_item(" " + str(Steam.getNumLobbyMembers(lobby)), null, false)
		lobby["LobbyId"].add_item(str(lobby), null, false)

func connected():
	add_player(multiplayer.get_unique_id())
	pass
	#add_player.rpc_id(1, multiplayer.get_unique_id())

func disconnected():
	push_warning("Connection lost")
	remove_player.rpc_id(multiplayer.get_unique_id())
	
@rpc("any_peer")
func add_player(id):
	var player_instance = player.instantiate()
	player_instance.name = str(id)
	server_node.add_child(player_instance)
	
@rpc("any_peer")
func remove_player(id):
	server_node.get_node_or_null(str(id)).queue_free()
