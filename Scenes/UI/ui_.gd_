extends Node

@export var fixed = true
@export var Items = {}
@export var Data = {}
@export var ListName = "Buildings"
@export var LastName = ""

func _ready():
	add_buildings_list()
	add_turrets_list()
	
func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		clear()
	if event.is_action_pressed("RMB"):
		for building in get_tree().get_nodes_in_group("selected"):
			menu(building.get_parent().get_parent().name)
	if event.is_action_pressed("Build"):
		menu("Buildings")
	if event.is_action_pressed("LMB"):
		if %Buildings.temp_instance:
			change_buildings(ListName,false)
			return
		if !active():
			menu("Buildings")
	for i in range(10):
		if i > $List.item_count:
			return
		if Input.is_key_pressed(KEY_0 + i):
			_on_list_item_selected(i)
	
func clear():
	for ui in get_children():
		if ui.get_class() == "ItemList":
			ui.deselect_all()
#		ui.hide()

func active():
	for ui in get_children():
		if ("List" in ui.name) && ui.visible:
			return ui

func _on_buildings_data():
	pass # Replace with function body.

func _on_list_item_selected(index):
	if index >= $List.item_count:
		return
	var text = $List.get_item_text(index)
	ListName = text
	if LastName == "":
		LastName = text
	if Items.has(text):
		menu(text)
		return
	change_buildings(text,true)
	LastName = text
	
func change_buildings(text,change):
	if !Items.has(ListName):
		ListName = LastName
	if %Buildings.temp_instance:
		if change:
			var instance = instance_from_id(%Buildings.temp_instance)
			instance.queue_free()
			instance = null
			%Buildings.temp_instance = null
	if %Buildings.temp_instance:
		%Buildings.load_script_from_name(%Buildings.temp_instance,ListName)
	%Buildings.instance_scene_from_name(LastName,ListName)

func dir_to_list(dir,dirname):
	var directory = DirAccess.open(dir)
	if !directory:
		return
	Items[dirname] = buildings_list(directory)
	
func buildings_list(directory):
	directory.list_dir_begin()  # skip navigation entries
	var list = []
	for building in directory.get_directories():
			if building.begins_with("Castle"):
				continue 
			list.append(building)
	return list

func menu(list):
	if !Items.has(list):
		return
	$List.clear()
	for item in Items[list]:
		$List.add_item(item)
	if Items[list]:
		$Numbers.update(Items[list].size())
	ListName = list
	$List.show()

func add_turrets_list():
	dir_to_list("res://Scenes/Building/Tower/Turrets/","Turrets")
	dir_to_list("res://Scenes/Building/Turret/","Turret")

func add_buildings_list():
	var buildings = "res://Scenes/Building/"
	dir_to_list(buildings,"Buildings")
	for building in Items["Buildings"]:
		if !%Buildings.get_node_or_null(building):
			continue
		var path = "res://Scenes/Building/"+building+"/"+building+".json"
		var file = FileAccess.open(path, FileAccess.READ).get_as_text()
		var json = JSON.parse_string(file)
		if !json.has("menu"):
			continue
		Items[building] = json["menu"]
