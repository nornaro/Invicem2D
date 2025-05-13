extends Panel

@onready var kafra_tab: PackedScene = preload("res://Scenes/UI/Kafra/kafra_tab.tscn")
var tabs:Dictionary = {}

func _ready() -> void:
	$Picker.position += size/20
	if !Global.Items.has("Buildings"):
		return
	for item:String in Global.Items["Buildings"]:
		var instance:Node = kafra_tab.instantiate()
		instance.name = item
		instance.add_to_group("Kafra"+item)
		%Tabs.add_child(instance)


func _input(_event: InputEvent) -> void:
	if Input.is_physical_key_pressed(KEY_K):
		visible = !visible
		
func select_tab(window: int) -> void: #,tab: int,data: Dictionary,_source: String,category: String
	show()
	%Tabs.set_current_tab(window-1)
	return
	#var tab = 0
	#for child in %Tabs.get_children():
		#if child.name != window:
			#tab += 1
			#continue
		#if  %Tabs.current_tab == tab:
			#return
	#return
		#%Tabs.clear_tabs()
	#for key: String in data.keys():
		#%Tabs.add_tab(key)
		#if !category:
			#continue
		#if key == category:
			#%Tabs.set_current_tab(%Tabs.tab_count-1)
		
