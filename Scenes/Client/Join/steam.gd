extends Node


#
#func fill_steam_lobby_menu(lobbies: Array):
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
