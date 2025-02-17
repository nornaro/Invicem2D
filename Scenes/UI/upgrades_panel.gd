extends GridContainer

@onready var button: PackedScene = preload("res://Scenes/UI/upgrade_button.tscn")
var icon_path: String = "res://Scenes/UI/Icon/"

func _ready() -> void:
	for i:int in range(12):
		var instance: Node = button.instantiate()
		instance.name = str(i+1)
		add_child(instance)
		clear()

func fill() -> void:
	clear()
	var data: Dictionary = get_tree().get_first_node_in_group("selected").get_parent().Data[name]
	var keys: Array = data.keys()
	for i: int in range(keys.size()):
		var node: Node = get_node(str(i+1))
		node.tooltip_text = keys[i]
		set_icon(node,keys[i])


func set_icon(node: Node,icon: String) -> void:
	if Global.RL.file_exists(icon_path+icon+".webp"):
		node.texture_normal = Global.RL.load(icon_path+icon+".webp")
		return
	node.texture_normal = Global.RL.load(icon_path+name+".webp")
	
		#var label = RichTextLabel.new()
		#label.name = "Label"
		#label.bbcode_enabled = true
		##label.self_modulate = Color.DARK_GREEN
		#label.set_anchors_preset(PRESET_FULL_RECT)
		#label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		#label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		#label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		#label.text = " [center][b][color=#808080][size=large]" + str(data[keys[i]]) + "[/size][/color][/b][/center] "
		#node.add_child(label)

func clear() -> void:
	for child: Node in get_children():
		child.tooltip_text = name
		set_icon(child,"")
		for grandchild: Node in child.get_children():
			grandchild.queue_free()
	
