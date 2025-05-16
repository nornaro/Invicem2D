extends Window

@export var tree_data: Dictionary = {}

func _ready():
    var tree = Tree.new()
    add_child(tree)
    tree.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    
    # Populate the tree with data
    var root = tree.create_item()
    _populate_tree(root, tree_data)

func _populate_tree(parent: TreeItem, data: Dictionary):
    for key in data:
        var item = parent.create_child()
        item.set_text(0, str(key))
        
        if typeof(data[key]) == TYPE_DICTIONARY:
            _populate_tree(item, data[key])
        else:
            item.set_text(1, str(data[key]))