extends Node

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
