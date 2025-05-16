extends Panel

@onready var kafra_tab: PackedScene = preload("res://Scenes/UI/Kafra/kafra_tab.tscn")

func _ready() -> void:
	position += size/20
	scale *= 0.9
	var i: int = 0
	if !Global.Items.has("Buildings"):
		return
	for item:String in Global.Items.Buildings:
		%CategoryTabs.add_tab(item)
		%CategoryTabs.category_tabs[item] = i
		i += 1

func _input(event: InputEvent) -> void:
	if event.is_action_released("kafra"):
		toggle()

func toggle() -> void:
	if visible:
		get_tree().call_group("Popup", "hide")
		get_tree().call_group("!Kafra", "show")
		return
	if !visible:
		get_tree().call_group("Popup", "hide")
		get_tree().call_group("!Kafra", "hide")
		show()

		

		
#func select_tab(item: String) -> void:
	#for child:TabBar in get_children():
		#if child.current_tab == item:
			#return
		#for tab in range(0,child.tab_count-1):
			#if child.get_tab_title(tab) != item:
				#continue
			#for tb:TabBar in get_tree().get_nodes_in_group("InventoryModuleTabs"):
				#tb.current_tab = -1
			#return
#
#func _on_tab_selected(item: int) -> void:
	#for child:TabBar in get_children():
		#if child.current_tab == item:
			#return
		#for tab in range(0,child.tab_count-1):
			#if child.get_tab_title(tab) != item:
				#continue
			#for tb:TabBar in get_tree().get_nodes_in_group("InventoryModuleTabs"):
				#tb.current_tab = -1
			#return

#func _on_tab_selected(item: int) -> void:
	
