extends ItemList

# Called when the node enters the scene tree for the first time.
func _ready():
	clear()
	var directory = DirAccess.open("res://Scenes/Buildings/Building/Tower/Turrets/")
	if directory:
		directory.list_dir_begin()
		var file_name = directory.get_next()
		while file_name != "":
			if file_name.ends_with(".tscn"):
				add_item(file_name.replace(".tscn", ""))
			file_name = directory.get_next()
		directory.list_dir_end()
	else:
		print("Failed to open directory.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_item_selected(index):
	var tower = instance_from_id($"../../Building".selected_building[0])
	var scene = load("res://turrets/"+get_item_text(index)+".tscn")
	
	var instance = scene.instantiate()
	instance.position = tower.position
	tower.add_child(instance)

	get_selected_items()
	hide()
