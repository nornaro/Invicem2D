extends TextureButton

var type:String

func _ready() -> void:
	connect("pressed", _on_pressed)
	
func _on_pressed() -> void:
	var node: Node = get_tree().get_first_node_in_group("selected")
	if !node:
		return
	get_tree().call_group("selected",type, self)
	if get_parent().name not in ["Modules","Inventory"]:
		return
	get_tree().call_group("CategoryTabs","set_tab",node.get_parent().get_parent().name)
	print(get_parent().name+"Tabs","_on_tab_changed",int(name))
	get_tree().call_group(get_parent().name+"Tabs","_on_tab_changed",int(name)-1)
	get_tree().call_group("Kafra","toggle")
	
