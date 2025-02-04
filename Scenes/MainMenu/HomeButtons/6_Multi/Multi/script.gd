extends Node

#@onready var network = preload("res://Scenes/Multiplayer/network.tscn")

var network: NetworkMgr
	
func _ready() -> void:
	get_parent().get_parent().connect("pressed", _on_pressed)
	
	
func _on_pressed() -> void:
	if !network:
		network = NetworkMgr.new()
	get_tree().call_group("MPHUD","show")
	#network.enter_tree()
