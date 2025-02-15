extends Node

const GAME_ID:String = "xcNhLTRbBH"

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
var servers:Dictionary = {}
var join_data:String
var server_id:String =""
var id:int
var C:Node
var game:String = "InvicemTD"

func console(txt:String) -> void:
	if !C:
		C = get_tree().get_first_node_in_group("Console")
	if !C:
		return
	C.text += str(txt) + "\n"
	
