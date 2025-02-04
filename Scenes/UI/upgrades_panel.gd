extends GridContainer

@onready var button = preload("res://Scenes/UI/upgrade_button.tscn")

func _ready() -> void:
	for i in range(9):
		var instance = button.instantiate()
		instance.name = str(i+1)
		add_child(instance)

func fill() -> void:
	clear()
	var keys: Array = get_tree().get_first_node_in_group("selected").get_parent().Data.Upgrades.keys()
	for i in range(keys.size()):  # Loop through all keys
		var node_index = int(i / 2) + 1  # Node numbers go from 1 to 9
		var node = get_node(str(node_index))  # Get the node based on the calculated index
		if i % 2 == 0:  # Even index: assign to the left
			node.left = keys[i]
			node.tooltip_text = keys[i]
		else:  # Odd index: assign to the right
			node.right = keys[i]
		node.tooltip_text = node.left + "/" + node.right

func clear() -> void:
	for child in get_children():
		child.tooltip_text = ""
		for grandchild in child.get_children():
			grandchild.queue_free()
