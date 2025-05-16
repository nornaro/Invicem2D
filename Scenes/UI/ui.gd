extends CanvasLayer

@export var fixed:bool = true
@export var Data:Dictionary = {}
var build:bool = false
var text:String = ""
var pressed:StringName
@onready var client: Node = $".."
@onready var blist: Node = $Control/List
@onready var bnumbers: Node = $Control/Numbers
#@onready var menu_bar: Node = $MenuBar

func _ready() -> void:
	blist.connect("item_selected",_on_list_item_selected)

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
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
		build_building(text, false)
		return
#		if !active():
#			menu("Buildings")
			
	for i:int in range(10):
		if !event is InputEventKey:
			return
		if !event.pressed:
			return
		if i > blist.item_count:
			return
		if event.is_action_pressed("Ctrl"):
			return
		if event.is_action_pressed("Shift"):
			return
		if Input.is_action_pressed(str(i)):
			pressed = str(i)
			_on_list_item_selected(i)

func build_building(txt:String, tf:bool) -> void:
	if !get_tree().get_first_node_in_group("Buildings"):
		return
	get_tree().get_first_node_in_group("Buildings").change_buildings(txt, tf)

func clear() -> void:
	for ui:Node in get_children():
		if ui.get_class() == "ItemList":
			ui.deselect_all()
	text = ""
	get_tree().call_group("Popup","hide")
	get_tree().call_group("!Kafra", "show")

func active() -> Node:
	for ui:Node in get_children():
		if ("List" in ui.name) && ui.visible:
			return ui
	return null

func _on_list_item_selected(index:int) -> void:
	if index >= blist.item_count:
		return
	text = blist.get_item_text(index)
	if text == "Turret":
		menu("Turret")
		return
	build_building(text, true)

#func buildings_list(directory):
	#directory.list_dir_begin()
	#var list = []
	#for building in directory.get_directories():
		#list.append(building)
	#return list

func menu(list:String) -> void:
	if !Global.Items.has(list):
		return
	blist.clear()
	if Global.Items[list].has("menu"):
		for item:Dictionary in Global.Items[list]["menu"]:
			blist.add_item(item)
	if !Global.Items[list].has("menu"):
		for item:String in Global.Items[list]:
			blist.add_item(item)
	if Global.Items[list]:
		bnumbers.update(Global.Items[list].size())
	blist.show()

		
#func _on_menu_bar_mouse_exited() -> void:
	#$MenuBar.hide()
#
#func _on_button_pressed() -> void:
	#$MenuBar.visible = !$MenuBar.visible
