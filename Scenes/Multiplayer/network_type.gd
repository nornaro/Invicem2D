extends TabBar

var network = NetworkMgr.new()

func _ready() -> void:
	connect("tab_changed", _on_tab_changed)

	
func _on_tab_changed(tab: int) -> void:
	for child in %Lobby.get_children():
		child.clear()
	match tab:
		0:
			network._enet_lobby_pressed()
		1:
			#Steam.addRequestLobbyListStringFilter("game", network.GAME_ID, Steam.LOBBY_COMPARISON_EQUAL)
			#Steam.addRequestLobbyListStringFilter("game", network.GAME_ID, Steam.LOBBY_COMPARISON_EQUAL)
			Steam.requestLobbyList()
			network._steam_lobby_pressed()
		2:
			network._nakama_lobby_pressed()
		3:
			network._gds_lobby_pressed()
		4:
			network._eos_lobby_pressed()
