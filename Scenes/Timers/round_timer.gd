extends Timer

@onready var servernode: Node
@onready var spawn: Node
@onready var minions: Node
var is_server = true

func _ready() -> void:
	start()
	if get_node_or_null("../Server"):
		servernode = $"../Server"
		return
	is_server = false
	spawn = $"../Client/Map/Spawn/CollisionShape2D"
	minions = $"../Client/Minions"


func _on_timeout() -> void:
	if !is_server:
		return
	if get_tree().get_nodes_in_group("minions").size() >= 2000:
		return
	for client in servernode.get_children():
		spawn = client.get_node("Map/Spawn/CollisionShape2D")
		minions = client.get_node("Minions")
		get_tree().call_group("Barrack", "spawn", minions, spawn)
