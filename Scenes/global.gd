extends Node

const GAME_ID:String = "xcNhLTRbBH"

@export var client: PackedScene = preload("res://Scenes/Multiplayer/2d_client.tscn")
@export var dummy_client: PackedScene = preload("res://Scenes/Multiplayer/dummy_client.tscn")
@export var style:String = "Sci-fi"
var peer: PacketPeer

var folders: Dictionary
var clients: Dictionary = {
	#"id": {
		#"name": "",
		#"hp": 0,
		#"score": 0,
	#}
}
var mp: bool = true
var Data: Dictionary
var Currecny: Dictionary = {
	"Minions": 100,
	"Power": 100,
	"Zeny": 100,
}
var counter:int
var RL:ResLoad = ResLoad.new()
#var threads:Dictionary = {
	#"minion":Thread.new(),
	#"projectile":Thread.new(),
	#"building":Thread.new(),
#}

var dedicated: bool = OS.has_feature("dedicated_server")
var servers:Dictionary = {}
var join_data:String
var server_id:String =""
var id:int
var C:Node
var game:String = "InvicemTD"
var start_port:int = 6666
var network_ports:Dictionary

func console(txt:String) -> void:
	if dedicated:
		return
	if !C:
		C = get_tree().get_first_node_in_group("Console")
	if !C:
		return
	C.text += str(txt) + "\n"
	
func _enter_tree() -> void:
	get_folders()
	
func get_folders(root:String = "res://Scenes/") -> void:
	for folder in DirAccess.get_directories_at(root):
		Global.folders[folder] = root+folder+"/"
		get_folders(Global.folders[folder])
