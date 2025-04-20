extends Node

var player: PackedScene
var port: int = 9001
var server_node: Node
var peer: SteamMultiplayerPeer = SteamMultiplayerPeer.new()
var is_owned: bool = false
var steam_app_id: int = 480 # Test game app id
var steam_id: int = 0
var steam_username: String = ""
var initialize_response: Dictionary
var _hosted_lobby_id:int = 0
const LOBBY_MODE = "FFA"
var refresh:float = 1.0

func host() -> void:
	initialize_steam()
	print_rich("Starting host!")
	server_node = get_tree().get_first_node_in_group("Server")
	server_node.player = Global.dummy_client
	Steam.lobby_joined.connect(_on_lobby_joined.bind())
	Steam.lobby_created.connect(_on_lobby_created.bind())
	multiplayer.peer_connected.connect(_connected)
	multiplayer.peer_disconnected.connect(_disconnected)
	Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, 16)

func initialize_steam() -> void:
	print_rich("Initializing host!")
	initialize_response = Steam.steamInitEx()
	if initialize_response['status'] > 0:
		push_warning("Failed to init Steam! %s" % initialize_response)
	is_owned = Steam.isSubscribed()
	steam_id = Steam.getSteamID()
	steam_username = Steam.getPersonaName()
	print_rich("steam_id: %s" % steam_id)
	if is_owned == false:
		push_error("User does not own game!")
		
func _physics_process(_delta:float) -> void:
	Steam.run_callbacks()
	#refresh -= delta
	#if refresh > 0:
		#return
	#refresh = 1.0
	
func _on_lobby_created(res: int, lobby_id:int) -> void:
	print_rich("Creating lobby")
	if res != 1:
		return
	_hosted_lobby_id = lobby_id
	Steam.setLobbyJoinable(_hosted_lobby_id, true)
	Steam.setLobbyData(_hosted_lobby_id, "game", Global.game)
	Steam.setLobbyData(_hosted_lobby_id, "mode", LOBBY_MODE)
	Steam.setLobbyData(_hosted_lobby_id, "UID", Global.uid)
	Steam.setLobbyData(_hosted_lobby_id, "name", "SteamTest")
	print_rich("Created lobby: %s" % _hosted_lobby_id)
	_create_host()

func _on_lobby_joined(lobby: int, _permissions: int, _locked: bool, response: int) -> void:
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
		print_rich(FAIL_REASON)
		return
	var id:int = Steam.getLobbyOwner(lobby)
	if id != Steam.getSteamID():
		print_rich("Connecting client to socket...")
		connect_socket(id)

func _create_host() -> void:
	var error:int = peer.create_host(0)
	if error != OK:
		print_rich("error creating host: %s" % str(error))
		return
	multiplayer.set_multiplayer_peer(peer)
	
func connect_socket(id: int) -> void:
	var error:int = peer.create_client(id, 0)
	if error != OK:
		print_rich("Error creating client: %s" % str(error))
		return
	print_rich("Connecting peer to host...")
	multiplayer.set_multiplayer_peer(peer)

func _connected(id: int) -> void:
	print_rich("Player %s joined the game!" % id)
	server_node.add_player(id)
	
func _disconnected(id: int) -> void:
	print_rich("Player %s left the game!" % id)
	server_node.remove_player(id)
