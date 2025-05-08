extends Node

const GAME_ID:String = "xcNhLTRbBH"


@export var client: PackedScene = preload("res://Scenes/Multiplayer/2d_client.tscn")
@export var dummy_client: PackedScene = preload("res://Scenes/Multiplayer/dummy_client.tscn")
@export var style:String = "Sci-fi"
var peer: PacketPeer
var clients: Dictionary = {
	#"id": {
		#"name": "",
		#"hp": 0,
		#"score": 0,
	#}
}
var mp: bool = true
var Data: Dictionary
var Items: Dictionary
var GetTree: SceneTree

#Data.Minions = 
#var type: String = Data.Minion[0]
#var minion: String = Data.Minion[1]
#var sprite: String = global[type][minion].keys().pick_random()
var Currecny: Dictionary = {
	"Minions": 100,
	"Power": 100,
	"Zeny": 100,
}

var RL:ResLoad = ResLoad.new()
#var threads:Dictionary = {
	#"minion":Thread.new(),
	#"projectile":Thread.new(),
	#"building":Thread.new(),
#}

#Global.discovery = Marshalls.utf8_to_base64(str(Time.get_ticks_msec()) + str(randf()))
var dedicated: bool = OS.has_feature("dedicated_server")
var servers:Dictionary = {}
var join_data:String
var server_id:String =""
var id:int
var C:Node
var uid:String = CryptoKey.generate_scene_unique_id()
var game:String = "InvicemTD"
var start_port:int = randi_range(6000,6666)
var network_ports:Dictionary
var search: bool = true

func console(txt:String) -> void:
	if dedicated:
		return
	if !C:
		C = get_tree().get_first_node_in_group("Console")
	if !C:
		return
	C.text += str(txt) + "\n"
	
