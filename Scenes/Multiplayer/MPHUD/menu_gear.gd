extends OptionButton

func _ready() -> void:
	connect("item_selected",_item_selected)
	
func _item_selected(index: int) -> void:
	match get_item_text(index):
		"Style":
			%Style.show_popup()
		"Exit":
			%Exit.show()
		"Reload":
			get_tree().reload_current_scene()
	_select_int(-1)
