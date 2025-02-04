extends Node
class_name NetworkMgr

const GAME_ID = "xcNhLTRbBH"

var port = 12345
var ip = '127.0.0.1'
var multiplayer_client = preload("res://Scenes/Client/2d_client.tscn")
var server_node: Node
var player_name: String
var players := {}
var players_ready := []
var steam_id: int
var player: PackedScene
var peer: PacketPeer

@onready var lobby_info: ItemList
@onready var lobby_name: ItemList
@onready var lobby_players: ItemList
@onready var lobby_id: ItemList











































#func host() -> void:
	#multiplayer.multiplayer_peer = peer
	#multiplayer.peer_connected.connect(add_player)
	#multiplayer.peer_disconnected.connect(remove_player)

## ENet (LAN) # https://docs.godotengine.org/en/stable/classes/class_enetconnection.html
#func _enet_host_pressed() -> void:
	#Global.peer = ENetMultiplayerPeer.new()
	#Global.peer.create_server(SERVER_PORT)
#
#func _enet_join_pressed() -> void:
	#Global.peer = ENetMultiplayerPeer.new()
	#Global.peer.create_client(SERVER_IP, SERVER_PORT)
#
#func _enet_lobby_pressed():
	#pass #udp broadcast

#server
#func _enet_host_pressed() -> void:
	#peer = ENetMultiplayerPeer.new()
	#peer.create_server(port)
	#multiplayer.multiplayer_peer = peer
	#multiplayer.peer_disconnected.connect(remove_player)
#
#
#
##client
#func _on_join_button_pressed() -> void:
	#player = load("res://Scenes/Client/2d_client.tscn")
	#peer.create_client(ip, port)
	#multiplayer.connected_to_server.connect(load_game)
	#multiplayer.server_disconnected.connect(connection_lost)
	#push_warning("Connecting to server...")
#
#func load_game():
	#add_player.rpc_id(1, multiplayer.get_unique_id())
	#push_warning("Connected to server.")
#
#func connection_lost():
	#pass
#
## rpc declaration must match server script, but definition can be different.
#func _input(event: InputEvent) -> void:
	#if event.is_action("ui_accept"):
		#var response = "My player name is: " + str(multiplayer.get_unique_id())
		#my_relay_rpc.rpc_id(1, response)

	#
###Steam # https://github.com/Zennyth/GodotSteam
#func _steam_host_pressed() -> void:
	#Steam.steamInitEx(true, 480)
	#Global.peer = SteamMultiplayerPeer.new()
	#Global.peer.create_host(port)
##
#func _steam_join_pressed() -> void:
	#Global.peer = SteamMultiplayerPeer.new()
	#Global.peer.create_client(steam_id, port)
#
#func _steam_lobby_pressed() -> void:
	#Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_CLOSE)
	#Steam.lobby_match_list.connect(fill_steam_lobby_menu)
	#Steam.addRequestLobbyListStringFilter("game", GAME_ID, Steam.LOBBY_COMPARISON_EQUAL)
	#Steam.requestLobbyList()
#
#func fill_steam_lobby_menu(lobbies: Array) -> void:
	#print(lobbies)
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
#
### Nakama # https://heroiclabs.com/docs/nakama/client-libraries/godot/
#func _nakama_host_pressed() -> void:
	#Global.peer = SteamMultiplayerPeer.new()
	#Global.peer.create_host(port)
#
#func _nakama_join_pressed() -> void:
	#Global.peer = SteamMultiplayerPeer.new()
	#Global.peer.create_client(steam_id, port)
#
#
### GD-Sync # https://www.gd-sync.com/
#func _gds_host_pressed() -> void:
	#Global.peer = SteamMultiplayerPeer.new()
	#Global.peer.create_host(port)
#
#func _gds_join_pressed() -> void:
	#Global.peer = SteamMultiplayerPeer.new()
	#Global.peer.create_client(steam_id, port)
#
#
### Epyc Games Online Service # https://github.com/Daylily-Zeleen/GD-EOS
#func _eos_host_pressed() -> void:
	#Global.peer = EOSMultiplayerPeer.new()
	#Global.peer.create_host(0, [])
#
#func _eos_join_pressed() -> void:
	#Global.peer = EOSMultiplayerPeer.new()
	#Global.peer.create_client()
#
#
### Common
#@rpc("any_peer")
#func add_player(id: int):
	#var instance = multiplayer_client.instantiate()
	#instance.player_id = id
	#instance.name = str(id)
	#server_node.add_child(instance, true)
#
#@rpc("any_peer")
#func remove_player(id: int):
	#if !server_node.has_node(str(id)):
		#return
	#server_node.get_node(str(id)).queue_free()
#
#@rpc("any_peer", "call_remote", "reliable")
#func my_relay_rpc(data: String):
	#print(data)
