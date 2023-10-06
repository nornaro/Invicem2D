@tool
extends MenuButton


func _ready() -> void:
	get_popup().connect("id_pressed", _on_menu_item_pressed)


func _on_menu_item_pressed(id: int) -> void:
	if id == 0:
		owner.run_simulation()
	elif id == 1:
		owner.clear_simulation()
