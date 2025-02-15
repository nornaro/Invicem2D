extends TabContainer

@onready var databox = preload("res://Scenes/Multiplayer/MPHUD/minion_data.tscn")
@onready var inventory = preload("res://Scenes/Multiplayer/MPHUD/minion_inventory.tscn")

func _ready() -> void:
	var data = Global.Data
	if !data.has(name+"s"):
		return
	var types = data[name+"s"].keys()
	for type in types:
		var instance:Node = inventory.instantiate()
		instance.name = type
		add_child(instance)
		fill(type)

func fill(type):
	var minions = Global.Data.Minions[type].keys()
	for minion in minions:
		var instance:Node = databox.instantiate()
		instance.name = minion
		var data = Global.Data.Minions
		var keys = Global.Data.Minions[type][minion].keys()
		var sprite = data[type][minion][keys.pick_random()]
		instance.get_node("HeadShot").texture = sprite.get_frame_texture("Idle",0)
		instance.get_node("Description").text = minion
		get_child(0).add_child(instance)
