extends GridContainer

var button = preload("res://Scenes/UI/info_panel.tscn")

func _ready() -> void:
	for i in range(3):
		var instance = button.instantiate()
		instance.name = str(i+1)
		add_child(instance)
		
func fill() -> void:
	var source = get_tree().get_first_node_in_group("selected")
	if !source:
		return
	var data: Dictionary = source.get_parent().Data
	clear()
	fill_1(data)
	fill_2(data)
	fill_3(data)
	
func	 fill_1(data):
	pass
func fill_2(data):
	pass
	
func fill_3(data):
	get_node(str(3) + "/" + str(1)).text = str(data["Properties"]).replace("{", "").replace("}", "").replace("\"", "").replace(",","\n")
	get_node(str(3) + "/" + str(1)).tooltip_text = "Properties"
	var text: String = ""
	var tab = 2  # Reset `tab` to 2 at the start of the method
	var line_count = 0  # To track the number of lines

	for line in str(data["Upgrades"]).replace("{", "").replace("}", "").replace("\"", "").split(","):
		text += line
		line_count += 1

		# After every 6 lines (5 newlines), reset the text and increment tab
		if line_count >= 6:
			get_node(str(3) + "/" + str(tab)).text = text
			get_node(str(3) + "/" + str(tab)).tooltip_text = "Upgrades"
			tab += 1  # Switch to the next tab
			text = ""  # Clear text for the next chunk
			line_count = 0  # Reset the line count
		else:
			text += "\n"  # Add newline if it's not the last chunk

	# If there are any leftover lines after the loop ends, process them
	if text != "":
		get_node(str(3) + "/" + str(tab)).text = text
		get_node(str(3) + "/" + str(tab)).tooltip_text = "Upgrades"

func _process(delta: float) -> void:
	fill()


func clear() -> void:
	for child in get_children():
		child.tooltip_text = name
		get_node(str(1)).text
		get_node(str(2)).text
		get_node(str(3)).text
		#for grandchild in child.get_children():
			#grandchild.queue_free()
