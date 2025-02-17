extends GridContainer

var button: PackedScene = preload("res://Scenes/UI/inventory_slot.tscn")
var icon_path: String = "res://Scenes/UI/Icon/"

func _ready() -> void:
	for i: int in range(4):
		var instance:Node = button.instantiate()
		instance.name = str(i+1)
		add_child(instance)
	clear()

func fill() -> void:
	clear()
	var data: Dictionary = get_tree().get_first_node_in_group("selected").get_parent().Data[name]
	var keys: Array = data.keys()
	for i: int in range(keys.size()):
		var node: Node = get_node(str(i+1))  # Get the node based on the calculated index
		node.tooltip_text = keys[i]
		set_icon(node,keys[i])

func set_icon(node: Node,icon: String) -> void:
	if Global.RL.file_exists(icon_path+icon+".webp"):
		node.texture_normal = Global.RL.load(icon_path+icon+".webp")
		return
	node.texture_normal = Global.RL.load(icon_path+name+".webp")

func clear() -> void:
	for child: Node in get_children():
		child.tooltip_text = name
		set_icon(child,"")
		for grandchild in child.get_children():
			grandchild.queue_free()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("RMB"):
		var data: Dictionary
		var node: Node = get_tree().get_first_node_in_group("selected")
		if node:
			data = node.get_parent().Data[name]
		if data.has(tooltip_text):
			data.erase(tooltip_text)
		
