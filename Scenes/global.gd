extends Node

const GAME_ID:String = "xcNhLTRbBH"

@export var style = "Sci-fi"
var peer: PacketPeer
var clients: Array
var clienthp: Dictionary
var mp: bool = true
var Data: Dictionary
var Currecny: Dictionary = {
	"Minions": 100,
	"Power": 100,
	"Zeny": 100,
}

var RL = ResLoad.new()

var servers = {}
var join_data
var server_id =""
var C
var game = "InvicemTD"

func console(txt) -> void:
	if !C:
		C = get_tree().get_first_node_in_group("Console")
	if !C:
		return
	C += str(txt) + "\n"
	
