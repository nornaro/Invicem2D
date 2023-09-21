extends ItemList

@onready var Building = $"../../Building"

func _ready():
	var directory = DirAccess.open("res://buildings/")
	if !directory:
		return
	directory.list_dir_begin()
	var file_name = directory.get_next()
	while file_name != "":
		if !file_name.ends_with(".tscn"):
			continue 
		if file_name == "Castle.tscn":
			continue 
		add_item(file_name.replace(".tscn", ""))
		file_name = directory.get_next()
	directory.list_dir_end()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_item_selected(index):
	if Building.instance:
		Building.instance.queue_free()
		Building.instance = null
	Building.instance_scene_from_name(get_item_text(index))

func _input(event):
	if !visible:
		return
	for i in range(10):# Loop through numbers 0-9
		if i > item_count:
			return
		if Input.is_key_pressed(KEY_0 + i):
			_on_item_selected(i)
