extends CanvasLayer

@export var fixed:bool = true
@export var Items:Dictionary = {}
@export var Data:Dictionary = {}
var build:bool = false
var text:String = ""
var pressed:StringName
@onready var client: Node = $".."
@onready var buildings: Node
var stylefolder: String

func _ready() -> void:
	$List.connect("item_selected",_on_list_item_selected)
	buildings = get_tree().get_first_node_in_group("Buildings")
	stylefolder = "res://Scenes/Build/Building/"
	dir_to_list(stylefolder, "Buildings")
	buildings.add_buildings_list(Items["Buildings"])
	buildings.build_castle("Castle")
	Items["Buildings"].erase("Castle")
	#dir_to_list(stylefolder + "Tower/", "Tower")
	#dir_to_list(stylefolder + "Tower/Turrets/", "Turrets")
	dir_to_list(stylefolder + "Turret/Type/", "Turret")
	add_json_list("Buildings")

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().call_group("Outline", "hide")
		buildings.clear_collision()
		clear()
	if pressed:
		if event.is_action_released(pressed):
			pressed = ""
			build = false
		return
						
	if event.is_action_pressed("RMB"):
		pressed = "RMB"
		for building in get_tree().get_nodes_in_group("selected"):
			menu(building.get_parent().get_parent().name)
		get_tree().call_group("Outline", "hide")
		get_tree().call_group("selected", "set_selected", false)
			
	if event.is_action_pressed("Build"):
		pressed = "Build"
		menu("Buildings")

	if event.is_action_pressed("LMB"):
		pressed = "LMB"
		build = true
		buildings.change_buildings(text, false)
		return
#		if !active():
#			menu("Buildings")
			
	for i:int in range(10):
		if !event is InputEventKey:
			return
		if !event.pressed:
			return
		if i > $List.item_count:
			return
		if event.is_action_pressed("Ctrl"):
			return
		if event.is_action_pressed("Shift"):
			return
		if Input.is_action_pressed(str(i)):
			pressed = str(i)
			_on_list_item_selected(i)

func clear() -> void:
	for ui:Node in get_children():
		if ui.get_class() == "ItemList":
			ui.deselect_all()
	text = ""

func active() -> Node:
	for ui:Node in get_children():
		if ("List" in ui.name) && ui.visible:
			return ui
	return null

func _on_list_item_selected(index:int) -> void:
	if index >= $List.item_count:
		return
	text = $List.get_item_text(index)
	if text == "Turret":
		menu("Turret")
		return
	buildings.change_buildings(text, true)

func dir_to_list(dir:String, dirname:String) -> void:
	var directory:Array = Global.RL.get_directories_at(dir)
	if !directory:
		return
	Items[dirname] = directory


#func buildings_list(directory):
	#directory.list_dir_begin()
	#var list = []
	#for building in directory.get_directories():
		#list.append(building)
	#return list

func menu(list:String) -> void:
	if !Items.has(list):
		return
	$List.clear()
	if Items[list].has("menu"):
		for item:Dictionary in Items[list]["menu"]:
			$List.add_item(item)
	if !Items[list].has("menu"):
		for item:String in Items[list]:
			$List.add_item(item)
	if Items[list]:
		$Numbers.update(Items[list].size())
	$List.show()

func add_json_list(list:String) -> void:
	for item:String in Items[list]:
		if !buildings.get_node_or_null(item):
			continue
		var path:String = stylefolder + item + "/" + item + ".json"
		var file:JSON = Global.RL.load(path)
		var json:Dictionary = file.get_data()
		if !json.has("menu"):
			continue
		if !Items.has(item):
			Items[item] = []
		Items[item].append(json)

		
func _on_menu_bar_mouse_exited() -> void:
	$MenuBar.hide()

func _on_button_pressed() -> void:
	$MenuBar.visible = !$MenuBar.visible
