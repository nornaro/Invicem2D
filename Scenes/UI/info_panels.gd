extends GridContainer

var button:PackedScene = preload("res://Scenes/UI/info_panel.tscn")

func _ready() -> void:
	for i: int in range(3):
		var instance: Node = button.instantiate()
		instance.name = str(i+1)
		add_child(instance)
		
func fill() -> void:
	var source: Node = get_tree().get_first_node_in_group("selected")
	if !source:
		return
	var data: Dictionary = source.get_parent().Data
	clear()
	fill_1(data)
	fill_2(data)
	fill_3(data)
	
func fill_1(_data:Dictionary) -> void:
	pass
func fill_2(_data:Dictionary) -> void:
	pass
	
func fill_3(data:Dictionary) -> void:
	var fill_node: RichTextLabel = get_node(str(3) + "/" + str(1))
	fill_node.text = str(data["Properties"]).replace("{", "").replace("}", "").replace(" ", "").replace("\"", "").replace(",","\n").replace(":",":\n\t")
	fill_node.tooltip_text = "Properties"
	fill_node.bbcode_enabled = true
	fill_node.add_theme_font_size_override("normal_font_size", 11)
	var text: String = ""
	var tab:int = 2  # Reset `tab` to 2 at the start of the method
	var line_count:int = 0  # To track the number of lines

	for line:String in str(data["Upgrades"]).replace("{", "").replace("}", "").replace("\"", "").split(","):
		text += line
		line_count += 1

		if line_count >= 8:
			get_node(str(3) + "/" + str(tab)).text = text
			get_node(str(3) + "/" + str(tab)).tooltip_text = "Upgrades"
			tab += 1  # Switch to the next tab
			text = ""  # Clear text for the next chunk
			line_count = 0  # Reset the line count
			continue
		text += "\n"  # Add newline if it's not the last chunk

	# If there are any leftover lines after the loop ends, process them
	if text != "":
		get_node(str(3) + "/" + str(tab)).text = text
		fill_node.add_theme_font_size_override("normal_font_size", 11)
		get_node(str(3) + "/" + str(tab)).tooltip_text = "Upgrades"

func  _physics_process(_delta: float) -> void:
	fill()


func clear() -> void:
	for child:Node in get_children():
		child.tooltip_text = name
		child.get_node(str(1)).text = ""
		child.get_node(str(2)).text = ""
		child.get_node(str(3)).text = ""
		#for grandchild in child.get_children():
			#grandchild.queue_free()
