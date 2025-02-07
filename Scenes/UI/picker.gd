extends Panel

func _input(_event: InputEvent) -> void:
	if Input.is_physical_key_pressed(KEY_K):
		visible = !visible
		
func equip(window,tab,data,source,category):
	for child in get_children():
		if child.name != window:
			child.hide()
			return
		child.show()
		if child.current_tab == tab:
			return
		child.set_current_tab(tab)
		$TabBar.clear_tabs()
	for key in data.keys():
		$TabBar.add_tab(key)
		if !category:
			continue
		if key == category:
			$TabBar.set_current_tab($TabBar.tab_count-1)
		
