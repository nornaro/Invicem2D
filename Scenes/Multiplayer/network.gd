extends Control


func _on_host_pressed() -> void:
	match %TabBar.current_tab:
		0:
			NetworkMgr._enet_host_pressed()
		1:
			NetworkMgr._steam_host_pressed()
		2:
			NetworkMgr._nakama_join_pressed()
		3:
			NetworkMgr._gds_join_pressed()
		4:
			NetworkMgr._eos_join_pressed()
	%Network.hide()


func _on_join_pressed() -> void:
	match %TabBar.current_tab:
		0:
			NetworkMgr._enet_join_pressed()
		1:
			NetworkMgr._steam_join_pressed()
		2:
			NetworkMgr._nakama_join_pressed()
		3:
			NetworkMgr._gds_join_pressed()
		4:
			NetworkMgr._eos_join_pressed()
	%Network.hide()


func _on_tab_bar_tab_changed(_tab: int) -> void:
	for child in %Lobby.get_children():
		child.clear()
	match %TabBar.current_tab:
		0:
			NetworkMgr._enet_lobby_pressed()
		1:
			Steam.addRequestLobbyListStringFilter("game", NetworkMgr.GAME_ID, Steam.LOBBY_COMPARISON_EQUAL)
			Steam.requestLobbyList()
			NetworkMgr._steam_lobby_pressed()
		2:
			NetworkMgr._nakama_lobby_pressed()
		3:
			NetworkMgr._gds_lobby_pressed()
		4:
			NetworkMgr._eos_lobby_pressed()
			
