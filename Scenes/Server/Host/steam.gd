extends Node

var player: PackedScene = preload("res://Scenes/Server/client.tscn")
var multiplayer_peer: SteamMultiplayerPeer = SteamMultiplayerPeer.new()
var port: int = 6666
var server_node: Node

var is_owned: bool = false
var steam_app_id: int = 480 # Test game app id
var steam_id: int = 0
var steam_username: String = ""
var _players_spawn_node
var _hosted_lobby_id = 0
const LOBBY_NAME = "InvicemTD"
const LOBBY_MODE = "BR"

var uid: String

func host() -> void:
	initialize_steam()
	server_node = get_tree().get_first_node_in_group("Server")
	uid = CryptoKey.generate_scene_unique_id()
	Steam.lobby_created.connect(_on_lobby_created.bind())
	multiplayer.peer_connected.connect(_connected)
	multiplayer.peer_disconnected.connect(_disconnected)
	Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, 128)
	set_process(true)

func initialize_steam():
	var initialize_response: Dictionary = Steam.steamInitEx()
	print("Did Steam Initialize?: %s " % initialize_response)
	
	if initialize_response['status'] > 0:
		print("Failed to init Steam! %s" % initialize_response)
		
	is_owned = Steam.isSubscribed()
	steam_id = Steam.getSteamID()
	steam_username = Steam.getPersonaName()

	print("steam_id: %s" % steam_id)
	
	if is_owned == false:
		print("User does not own game!")

func _connected(id) -> void:
	add_player(id)
	
func _disconnected(id) -> void:
	remove_player(id)

func _on_lobby_created(connect: int, lobby_id):
	print("On lobby created")
	if connect == 1:
		_hosted_lobby_id = lobby_id
		print("Created lobby: %s" % _hosted_lobby_id)
		Steam.setLobbyJoinable(_hosted_lobby_id, true)
		Steam.setLobbyData(_hosted_lobby_id, "game", Global.game)
		Steam.setLobbyData(_hosted_lobby_id, "mode", LOBBY_MODE)
		Steam.setLobbyData(_hosted_lobby_id, "UID", uid)
		Steam.setLobbyData(_hosted_lobby_id, "name", "SteamTest")
		
		_create_host()

func _create_host():
	var error = multiplayer_peer.create_host(6666)
	if error == OK:
		multiplayer.set_multiplayer_peer(multiplayer_peer)
		return
	print("Error creating host: %s" % str(error))

func _process(delta: float) -> void:
	Steam.run_callbacks()

@rpc("any_peer", "call_remote", "reliable")
func my_relay_rpc(data: String):
	print_debug(data)

@rpc("any_peer")
func add_player(id):
	if server_node.get_node_or_null(str(id)):
		return
	var player_instance = player.instantiate()
	player_instance.name = str(id)
	server_node.add_child(player_instance, true)
	Global.clients[id] = {}
	Global.clients[id]["hp"] = 100
	Global.clients[id]["score"] = 0
	Global.clients[id]["name"] = ""

@rpc("any_peer")
func remove_player(id):
	if server_node.has_node(str(id)):
		server_node.get_node(str(id)).queue_free()
		Global.clients.erase(id)

func _on_connected_to_server():
	print_debug("Successfully connected to server!")
