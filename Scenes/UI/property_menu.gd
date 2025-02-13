extends GridContainer

var root = "res://Scenes/Building/"
var scene = preload("res://Scenes/UI/item_list.tscn")
var button = preload("res://Scenes/UI/property_menu_button.tscn")
var icon_path = "res://Scenes/UI/Icon/"

func _ready() -> void:
	for i in range(4):
		var instance = button.instantiate()
		instance.name = str(i+1)
		instance.connect("pressed",list)
		add_child(instance)
	clear()

func fill() -> void:
	clear()
	var source = get_tree().get_first_node_in_group("selected")
	var data: Dictionary = source.get_parent().Data[name]
	var keys: Array = data.keys()
	for i in range(data.size()):
		var node = get_node(str(i+1))
		node.tooltip_text = keys[i]
		set_icon(node,keys[i])
		list(source,node,data,keys[i])
		
func set_icon(node,icon):
	if Global.RL.file_exists(icon_path+icon+".png"):
		node.texture_normal = Global.RL.load(icon_path+icon+".png")
		return
	if Global.RL.file_exists(icon_path+name+".png"):
		node.texture_normal = Global.RL.load(icon_path+name+".png")
		return
	node.texture_normal = ImageTexture.new(	)
	
func list(source,node,data,key):
	var itemlist:ItemList = scene.instantiate()
	var path = root + source.get_parent().get_parent().name + "/Menu/" + key
	var menu_list = Global.RL.get_files_at(path)
	if !list:
		return
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

func clear() -> void:
	for child in get_children():
		child.tooltip_text = name
		set_icon(child,"")
		for grandchild in child.get_children():
			grandchild.queue_free()
