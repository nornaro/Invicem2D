extends Timer

@export var Data = {}
var parent: Node

func _ready() -> void:
	connect("timeout",revert)
	parent = get_parent()
	for keys in Data.keys():
		parent.Data.key += Data.key
	start()

func revert():
	for keys in Data.keys():
		parent.Data.key -= Data.key
