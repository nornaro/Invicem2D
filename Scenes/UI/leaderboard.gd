extends TabContainer

var player: PackedScene = preload("leaderboard.tscn")
var score: int = 1

func _ready() -> void:
	connect("tab_clicked",_change_sort)

func update(clients:Dictionary) -> void:
	var id: int = multiplayer.get_unique_id()
	var n: int = 0
	var players: Array = []
	var sort_key:Array
	if score:
		sort_key = ["score","hp",]
	if !score:
		sort_key = ["hp","score",]
	players.append(str(clients[id][sort_key[0]]) + "¤" + str(clients[id][sort_key[1]]) + "¤" + clients[id].name)
	for client: int in clients:
		players.append(str(clients[client][sort_key[0]], "¤", clients[client][sort_key[1]], "¤", clients[client].name))
	players.sort()
	players.reverse()
	players.resize(clamp(players.size(),players.size(),10))
	for p:String in players:
		var player_parts: Array = p.split("¤")
		get_node("Scoreboard/" + str(n) + "/HP").text = player_parts[score]
		get_node("Scoreboard/" + str(n) + "/Score").text = player_parts[1 - score]
		get_node("Scoreboard/" + str(n) + "/Name").text = player_parts[2]
		n += 1
	
	
func _change_sort() -> void:
	score = 1 - score
	
