extends Panel

@onready var kafra_tab: PackedScene = preload("res://Scenes/UI/Kafra/kafra_tab.tscn")

func _ready() -> void:
	$Picker.position += size/20
	if !Global.Items.has("Buildings"):
		return
	for item:String in Global.Items["Buildings"]:
		var instance:Node = kafra_tab.instantiate()
		instance.name = item
		%Tabs.add_child(instance)


func _input(_event: InputEvent) -> void:
	if Input.is_physical_key_pressed(KEY_K):
		visible = !visible
		
func select_tab(window: String,tab: int,data: Dictionary,_source: String,category: String) -> void:
	for child in get_children():
		if child.name != window:
			child.hide()
			return
		child.show()
		if child.current_tab == tab:
			return
		child.set_current_tab(tab)
		%Tabs.clear_tabs()
	for key: String in data.keys():
		%Tabs.add_tab(key)
		if !category:
			continue
		if key == category:
			%Tabs.set_current_tab(%Tabs.tab_count-1)
		
