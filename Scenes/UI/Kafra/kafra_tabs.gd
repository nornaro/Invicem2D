extends TabBar

var category_tabs: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("tab_changed",_on_tab_changed)
	current_tab = -1

func set_tab(tab:String) -> void:
	_on_tab_changed(category_tabs[tab])

func _on_tab_changed(tab: int) -> void:
	match name:
		"ModulesTabs": 
			%InventoryTabs.current_tab = -1
			current_tab = tab
			return
		"InventoryTabs": 
			%ModulesTabs.current_tab = -1
			current_tab = tab
			return
	current_tab = tab
