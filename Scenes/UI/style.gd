extends OptionButton

func _ready() -> void:
	connect("item_selected",_on_item_selected)

func _on_item_selected(index: int) -> void:
	Global.style = get_item_text(index)
	get_tree().call_group("BuildingSprite","set_random")
	_select_int(-1)
 
