extends ItemList

# Called when the node enters the scene tree for the first time.
func _ready():
	var directory = DirAccess.open("res://turrets/")
	if directory:
		directory.list_dir_begin()
		var file_name = directory.get_next()
		while file_name != "":
			if file_name.ends_with(".tscn") and file_name != "Castle.tscn":
				add_item(file_name.replace(".tscn", ""))
			file_name = directory.get_next()
		directory.list_dir_end()
	else:
		print("Failed to open directory.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_item_selected(_index):
	get_selected_items()
	hide()
