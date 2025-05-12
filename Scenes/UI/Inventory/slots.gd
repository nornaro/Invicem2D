extends Control

var root: String = "res://Scenes/Buildings/Building/"
var button: PackedScene = preload("res://Scenes/UI/Inventory/slot.tscn")
var icon_path: String = "res://Scenes/UI/Icon/"
var item_list_scene: PackedScene = preload("res://Scenes/UI/item_list.tscn")

func _ready() -> void:
	for i: int in range(int(get_meta("size") if has_meta("size") else 4)):
		var instance:Node = button.instantiate()
		instance.name = str(i+1)
		add_child(instance)
	clear()

func fill() -> void:
	clear()
	var source: Node = get_tree().get_first_node_in_group("selected")
	if !source.get_parent().Data.has(name):
		return
	var data: Dictionary = source.get_parent().Data[name]
	var keys: Array = data.keys()
	for i: int in range(data.size()):
		var node: Node = get_node(str(i+1))
		node.tooltip_text = keys[i]
		#node.name = keys[i]
		node.type = name.to_lower()
		set_icon(node,keys[i])
		list(source,node,data,keys[i])

func list(source: Node,node: Node,data: Dictionary,key: String) -> void:
	var itemlist:ItemList = item_list_scene.instantiate()
	var path: String = root + source.get_parent().get_parent().name + "/Menu/" + key
	var menu_list: Array = Global.RL.get_files_at(path)
	for item:String in menu_list:
		if !item.ends_with("gd"):
			continue
		item = item.split(".")[0]
		if item.contains("_"):
			item = item.split("_")[1]
		itemlist.add_item(item)
		if data[key] == item:
			itemlist.select(itemlist.item_count-1)
	node.add_child(itemlist)

func set_icon(node: Node,icon: String) -> void:
	if Global.RL.file_exists(icon_path+icon+".webp"):
		node.texture_normal = Global.RL.load(icon_path+icon+".webp")
		return
	node.texture_normal = Global.RL.load(icon_path+"Slots.webp")

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
		if node && node.get_parent().Data.has(name):
				data = node.get_parent().Data[name]
		if data.has(tooltip_text):
			data.erase(tooltip_text)
		
