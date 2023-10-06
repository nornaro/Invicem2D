extends Node

@export var fixed = true
@export var Items = {}
@export var Data = {}
var build = false
var text = ""
var pressed = false

func _ready():
	dir_to_list("res://Scenes/Building/", "Buildings")
	%Buildings.add_buildings_list(Items)
	dir_to_list("res://Scenes/Building/Tower/", "Tower")
	dir_to_list("res://Scenes/Building/Tower/Turrets/", "Turrets")
	dir_to_list("res://Scenes/Building/Turret/", "Turret")
	add_json_list("Buildings")

func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		%Buildings.clear_collision()
		clear()
	if pressed:
		if event.is_action_released(pressed):
			pressed = null
			build = false
		return
						
	if event.is_action_pressed("RMB"):
		pressed = "RMB"
		for building in get_tree().get_nodes_in_group("selected"):
			menu(building.get_parent().get_parent().name)
			
	if event.is_action_pressed("Build"):
		pressed = "Build"
		menu("Buildings")

	if event.is_action_pressed("LMB"):
		pressed = "LMB"
		build = true
		%Buildings.change_buildings(text, false)
		return
#		if !active():
#			menu("Buildings")
			
	for i in range(10):
		if i > $List.item_count:
			return
		if Input.is_action_pressed(str(i)):
			pressed = str(i)			
			_on_list_item_selected(i)

func clear():
	for ui in get_children():
		if ui.get_class() == "ItemList":
			ui.deselect_all()
	text = ""

func active():
	for ui in get_children():
		if ("List" in ui.name) && ui.visible:
			return ui

func _on_list_item_selected(index):
	if index >= $List.item_count:
		return
	text = $List.get_item_text(index)
	if text == "Turret":
		menu("Turret")
		return
	%Buildings.change_buildings(text, true)

func dir_to_list(dir, dirname):
	var directory = DirAccess.open(dir)
	if !directory:
		return
	Items[dirname] = buildings_list(directory)

func buildings_list(directory):
	directory.list_dir_begin()
	var list = []
	for building in directory.get_directories():
		list.append(building)
	return list

func menu(list):
	if !Items.has(list):
		return
	$List.clear()
	if Items[list].has("menu"):
		for item in Items[list]["menu"]:
			$List.add_item(item)
	if !Items[list].has("menu"):
		for item in Items[list]:
			$List.add_item(item)
	if Items[list]:
		$Numbers.update(Items[list].size())
	$List.show()

func add_json_list(list):
	for item in Items[list]:
		if !%Buildings.get_node_or_null(item):
			continue
		var path = "res://Scenes/Building/" + item + "/" + item + ".json"
		var file = FileAccess.open(path, FileAccess.READ).get_as_text()
		var json = JSON.parse_string(file)
		if !json.has("menu"):
			continue
		if !Items.has(item):
			Items[item] = []
		Items[item].append(json)
