extends Timer



@export var Data: Dictionary = {}
var parent: Node

func _ready() -> void:
	connect("timeout",revert)
	parent = get_parent()
	for keys:String in Data.keys():
		parent.Data.key += Data.key
	start()

func revert() -> void:
	for keys:String in Data.keys():
		parent.Data.key -= Data.key
