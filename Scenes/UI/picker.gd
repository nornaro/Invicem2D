extends Panel

func _input(_event: InputEvent) -> void:
	if Input.is_physical_key_pressed(KEY_K):
		visible = !visible
		
func equip(window: String,tab: int,data: Dictionary,_source: String,category: String) -> void:
	for child in get_children():
		if child.name != window:
			child.hide()
			return
		child.show()
		if child.current_tab == tab:
			return
		child.set_current_tab(tab)
		$TabBar.clear_tabs()
	for key: String in data.keys():
		$TabBar.add_tab(key)
		if !category:
			continue
		if key == category:
			$TabBar.set_current_tab($TabBar.tab_count-1)
		
