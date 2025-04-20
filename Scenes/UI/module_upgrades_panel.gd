extends GridContainer

@onready var button: PackedScene = preload("res://Scenes/UI/upgrade_button.tscn")
"""	
func _ready() -> void:
	for i: int in range(12):
		var instance:Node = button.instantiate()
		instance.name = str(i+1)
		add_child(instance)

func fill() -> void:
	clear()
	var data: Dictionary = get_tree().get_first_node_in_group("selected").get_parent().Data.Upgrades
	var keys: Array = data.keys()
	for i: int in range(keys.size()):
		var node: Node = get_node(str(i+1))  # Get the node based on the calculated index
		node.tooltip_text = keys[i]
	#for i: int in range(keys.size()):  # Loop through all keys
		#var node_index = int(i / 2.0) + 1  # Node numbers go from 1 to 9
		#var node: Node = get_node(str(node_index))  # Get the node based on the calculated index
		#if i % 2 != 0:  # Even index: assign to the left
			#node.right = keys[i]
			#return
		#node.left = keys[i]
		#node.tooltip_text = keys[i]
		##node.tooltip_text = node.left + "/" + node.right

func clear() -> void:
	for child in get_children():
		child.tooltip_text = name
		for grandchild in child.get_children():
			grandchild.queue_free()
"""	
