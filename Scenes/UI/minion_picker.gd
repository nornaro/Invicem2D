extends ScrollContainer

@onready var databox:PackedScene = preload("res://Scenes/UI/minion_data.tscn")
@onready var inventory:PackedScene = preload("res://Scenes/UI/minion_inventory.tscn")

func _ready() -> void:
	var data:Dictionary = Global.Data
	if !data.has(name+"s"):
		return
	var types:Array = data[name+"s"].keys()
	for type:String in types:
		var instance:Node = inventory.instantiate()
		instance.name = type
		add_child(instance)
		fill(type)

func fill(type:String) -> void:
	var minions:Array = Global.Data.Minions[type].keys()
	for minion:String in minions:
		var instance:Node = databox.instantiate()
		instance.name = minion
		var data:Dictionary = Global.Data.Minions
		var keys:Array = data[type][minion].keys()
		var sprite:SpriteFrames = data[type][minion][keys.pick_random()]
		instance.get_node("HeadShot").texture = sprite.get_frame_texture("Idle",0)
		instance.get_node("Description").text = minion
		get_child(0).add_child(instance)
