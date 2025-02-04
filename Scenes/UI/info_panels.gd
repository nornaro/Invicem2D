extends GridContainer

var button = preload("res://Scenes/UI/info_panel.tscn")

func _ready() -> void:
	for i in range(3):
		var instance = button.instantiate()
		instance.name = str(i+1)
		add_child(instance)
		
func fill() -> void:
	clear()
	var keys: Array = get_tree().get_first_node_in_group("selected").get_parent().Data.Info.keys()
	for i in range(keys.size()-1):
		var node = get_node(str(i+1))
		node.tooltip_text = keys[i]

func clear() -> void:
	for child in get_children():
		child.tooltip_text = ""
		for grandchild in child.get_children():
			grandchild.queue_free()
