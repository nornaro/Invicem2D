extends TabBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("tab_changed",_on_tab_changed)
	current_tab = -1

func _on_tab_changed(tab: int) -> void:
	match name:
		"ModuleTabs": 
			%InventoryTabs.current_tab = -1
			current_tab = tab
		"InventoryTabs": 
			%ModuleTabs.current_tab = -1
			current_tab = tab
