extends GridContainer

var button = preload("res://Scenes/UI/equip_slot.tscn")
var icon_path = "res://Scenes/UI/Icon/"

func _ready() -> void:
	for i in range(4):
		var instance = button.instantiate()
		instance.name = str(i+1)
		add_child(instance)
	clear()

func fill() -> void:
	clear()
	var data: Dictionary = get_tree().get_first_node_in_group("selected").get_parent().Data[name]
	var keys: Array = data.keys()
	for i in range(keys.size()):
		var node = get_node(str(i+1))  # Get the node based on the calculated index
		node.tooltip_text = str(data[keys[i]])
		set_icon(node,keys[i])

func set_icon(node,icon):
	if Global.RL.file_exists(icon_path+icon+".png"):
		node.texture_normal = Global.RL.load(icon_path+icon+".png")
		return
	node.texture_normal = Global.RL.load(icon_path+name+".png")
			

func clear() -> void:
	for child in get_children():
		child.tooltip_text = name
		set_icon(child,"")
		for grandchild in child.get_children():
			grandchild.queue_free()
