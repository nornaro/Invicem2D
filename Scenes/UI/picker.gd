extends Panel

@onready var databox:PackedScene = preload("res://Scenes/UI/kafra_item_data.tscn")
#@onready var inventory:PackedScene = preload("res://Scenes/UI/minion_inventory.tscn")

func _ready() -> void:
	var data:Dictionary = Global.Data
	if !data.has(name+"s"):
		return
	var types:Array = data[name+"s"].keys()
	for type:String in types:
		#var instance:Node = inventory.instantiate()
		#instance.name = type
		#add_child(instance)
		fill(type)

func fill(type:String) -> void:
	print(Global.Data[name])
	for item:String in Global.Data[name][type].keys():
		var instance:Node = databox.instantiate()
		instance.name = item
		var data:Dictionary = Global.Data.Minions
		var keys:Array = data[type][item].keys()
		var sprite:SpriteFrames = data[type][item][keys.pick_random()]
		$Image.texture = sprite.get_frame_texture("Idle",0)
		$Description.text = item
