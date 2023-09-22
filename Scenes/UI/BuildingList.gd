extends ItemList

@onready var Buildings = $"../../Buildings"

func _ready():
	var dir = DirAccess.open("res://Scenes/Buildings/Building")
	if !dir:
		return
	add_to_list(buildings_list(dir))
	
func add_to_list(list):
	for building in list:
		if building == "Castle":
			continue 
		add_item(building)
		
func buildings_list(directory):
	directory.list_dir_begin()  # skip navigation entries
	var list = []
	for file_name in directory.get_files():
		if file_name.ends_with(".png"):
			list.append(file_name.replace(".png", ""))
	return list
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_item_selected(index):
	if Buildings.temp_instance:
		Buildings.temp_instance.queue_free()
		Buildings.temp_instance = null
	Buildings.instance_scene_from_name(get_item_text(index))

func _input(_event):
	if !visible:
		return
	for i in range(10):# Loop through numbers 0-9
		if i > item_count:
			return
		if Input.is_key_pressed(KEY_0 + i):
			_on_item_selected(i)
