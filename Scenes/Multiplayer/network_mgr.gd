extends Control

const GAME_ID = "xcNhLTRbBH"
const SERVER_PORT = 12345
const SERVER_IP = '127.0.0.1'

var multiplayer_scene = preload("res://Scenes/Client/2d_client.tscn")
var players_node: Node
var player_name: String
var players := {}
var players_ready := []
var steam_id: int

@onready var lobby_info: ItemList
@onready var lobby_name: ItemList
@onready var lobby_players: ItemList
@onready var lobby_id: ItemList

func _ready() -> void:
	Steam.steamInitEx(true, 480)

## ENet (LAN) # https://docs.godotengine.org/en/stable/classes/class_enetconnection.html
func _enet_host_pressed() -> void:
	players_node = get_tree().get_first_node_in_group("Players")
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(SERVER_PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	#add_player(1)

func _enet_join_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	multiplayer.multiplayer_peer = peer

func _enet_lobby_pressed():
	pass #udp broadcast
	
##Steam # https://github.com/Zennyth/GodotSteam
func _steam_host_pressed() -> void:
	players_node = get_tree().get_first_node_in_group("Players")
	var peer = SteamMultiplayerPeer.new()
	peer.create_host(SERVER_PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	#add_player(1)
#
func _steam_join_pressed() -> void:
	var peer = SteamMultiplayerPeer.new()
	peer.create_client(steam_id, SERVER_PORT)
	multiplayer.multiplayer_peer = peer

func _steam_lobby_pressed() -> void:
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_CLOSE)
	Steam.lobby_match_list.connect(fill_steam_lobby_menu)
	#Steam.addRequestLobbyListStringFilter("game", GAME_ID, Steam.LOBBY_COMPARISON_EQUAL)
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


## Nakama # https://heroiclabs.com/docs/nakama/client-libraries/godot/
func _nakama_host_pressed() -> void:
	players_node = get_tree().get_first_node_in_group("Players")
	var peer = SteamMultiplayerPeer.new()
	peer.create_host(SERVER_PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	add_player(1)
	pass
#
func _nakama_join_pressed() -> void:
	var peer = SteamMultiplayerPeer.new()
	peer.create_client(steam_id, SERVER_PORT)
	multiplayer.multiplayer_peer = peer
	pass


## GD-Sync # https://www.gd-sync.com/
func _gds_host_pressed() -> void:
	players_node = get_tree().get_first_node_in_group("Players")
	var peer = SteamMultiplayerPeer.new()
	peer.create_host(SERVER_PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	add_player(1)
	pass
#
func _gds_join_pressed() -> void:
	var peer = SteamMultiplayerPeer.new()
	peer.create_client(steam_id, SERVER_PORT)
	multiplayer.multiplayer_peer = peer
	pass


## Epyc Games Online Service # https://github.com/Daylily-Zeleen/GD-EOS
func _eos_host_pressed() -> void:
	players_node = get_tree().get_first_node_in_group("Players")
	var peer = EOSMultiplayerPeer.new()
	peer.create_host(0, [])
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	add_player(1)
	pass
#
func _eos_join_pressed() -> void:
	var peer = EOSMultiplayerPeer.new()
	#peer.create_client()
	multiplayer.multiplayer_peer = peer
	pass


## Common
func add_player(id: int):
	var instance = multiplayer_scene.instantiate()
	instance.player_id = id
	instance.name = str(id)
	players_node.add_child(instance, true)

func remove_player(id: int):
	if !players_node.has_node(str(id)):
		return
	players_node.get_node(str(id)).queue_free()
