@tool
extends MenuButton


func _ready() -> void:
	get_popup().connect("id_pressed", _on_menu_item_pressed)


func _on_menu_item_pressed(id: int) -> void:
	if id == 0:
		owner.rotate_inwards()
	elif id == 1:
		owner.rotate_outwards()
	elif id == 2:
		pass#owner.rotate_parallel()
	elif id == 3:
		pass#owner.rotate_focused()
	elif id == 5:
		owner.rotate_random()
