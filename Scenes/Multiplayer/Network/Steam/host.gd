extends Node

var player: PackedScene
var multiplayer_peer: SteamMultiplayerPeer = SteamMultiplayerPeer.new()
var port: int
var server_node: Node

var is_owned: bool = false
var steam_app_id: int = 480 # Test game app id
var steam_id: int = 0
var steam_username: String = ""
var _hosted_lobby_id:int = 0
const LOBBY_NAME:String = "InvicemTD"
const LOBBY_MODE:String = "BR"

var uid: String

func host() -> void:
	player = Global.dummy_client
	initialize_steam()
	server_node = get_tree().get_first_node_in_group("Server")
	uid = CryptoKey.generate_scene_unique_id()
	Steam.lobby_created.connect(_on_lobby_created.bind())
	multiplayer.peer_connected.connect(_connected)
	multiplayer.peer_disconnected.connect(_disconnected)
	Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, 128)
	set_process(true)

func initialize_steam() -> void:
	var initialize_response: Dictionary = Steam.steamInitEx()
	print_rich("Did Steam Initialize?: %s " % initialize_response)
	
	if initialize_response['status'] > 0:
		push_warning("Failed to init Steam! %s" % initialize_response)
		
	is_owned = Steam.isSubscribed()
	steam_id = Steam.getSteamID()
	steam_username = Steam.getPersonaName()

	print_rich("steam_id: %s" % steam_id)
	
	if is_owned == false:
		push_error("User does not own game!")

func _connected(id:int) -> void:
	add_player(id)
	
func _disconnected(id:int) -> void:
	remove_player(id)

func _on_lobby_created(res: int, lobby_id:int) -> void:
	print_rich("On lobby created")
	if res != 1:
		return
	_hosted_lobby_id = lobby_id
	print_rich("Created lobby: %s" % _hosted_lobby_id)
	Steam.setLobbyJoinable(_hosted_lobby_id, true)
	Steam.setLobbyData(_hosted_lobby_id, "game", Global.game)
	Steam.setLobbyData(_hosted_lobby_id, "mode", LOBBY_MODE)
	Steam.setLobbyData(_hosted_lobby_id, "UID", uid)
	Steam.setLobbyData(_hosted_lobby_id, "name", "SteamTest")
	_create_host()

func _create_host() -> void:
	var error:int = multiplayer_peer.create_host(port)
	if error == OK:
		multiplayer.set_multiplayer_peer(multiplayer_peer)
		return
	push_warning("Error creating host: %s" % str(error))

func _process(_delta: float) -> void:
	Steam.run_callbacks()

@rpc("any_peer", "call_remote", "reliable")
func my_relay_rpc(data: String) -> void:
	print_debug(data)

@rpc("any_peer")
func add_player(id:int) -> void:
	if server_node.get_node_or_null(str(id)):
		return
	var player_instance:Node = player.instantiate()
	player_instance.name = str(id)
	server_node.add_child(player_instance, true)
	Global.clients[id] = {}
	Global.clients[id]["hp"] = 100
	Global.clients[id]["score"] = 0
	Global.clients[id]["name"] = ""

@rpc("any_peer")
func remove_player(id:int) -> void:
	if server_node.has_node(str(id)):
		server_node.get_node(str(id)).queue_free()
		Global.clients.erase(id)

func _on_connected_to_server() -> void:
	print_debug("Successfully connected to server!")
