extends ItemList

@export var Items = {}
@onready var Buildings = $"../../Buildings"

func _ready():
	var buildings = "res://Scenes/Buildings/Building/"
	dir_to_list(buildings,"Buildings")
	for building in Items["Buildings"]:
		if Buildings.get_node(building).Data.has(menu):
			dir_to_list(building,Buildings.get_node(building).Data["menu"])

func dir_to_list(dir,dirname):
	var directory = DirAccess.open(dir)
	if !directory:
		return
	print(dirname)
	Items[dirname] = buildings_list(directory)
	
func buildings_list(directory):
	directory.list_dir_begin()  # skip navigation entries
	var list = []
	for file_name in directory.get_files():
		if file_name.ends_with(".png"):
			if file_name.begins_with("Castle"):
				continue 
			list.append(file_name.replace(".png", ""))
	return list

func _on_item_selected(index):
	var text = get_item_text(index)
	if Buildings.temp_instance:
		Buildings.temp_instance.queue_free()
		Buildings.temp_instance = null
		Buildings.instance_scene_from_name(text)
		return
	if Items["Buildings"].has(text):
		Buildings.instance_scene_from_name(text)
	if Items.has(text):
		menu(text)

func menu(list):
	clear()
	if !Items.has(list):
		return
	for item in Items[list]:
		add_item(item)
	$"../Numbers".update(Items[list].size())
	show()

func _input(_event):
	if !visible:
		return
	for i in range(10):# Loop through numbers 0-9
		if i > item_count:
			return
		if Input.is_key_pressed(KEY_0 + i):
			_on_item_selected(i)

#func _on_building_menu_item_selected(index):
#	if BuildingMenu.get_item_text(index) == "Turret >":
#		BuildingMenu.hide()
#		TurretList.show()
#		if !UI.fixed: TurretList.position = BuildingMenu.position
#	return
