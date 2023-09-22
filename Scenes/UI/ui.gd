extends Node

@export var fixed = true

func _input(_event):
	if Input.is_key_pressed(KEY_ESCAPE):
		clear()
	
func clear():
	for ui in get_children():
		if ui.get_class() == "ItemList":
			ui.deselect_all()
		ui.hide()

func active():
	for ui in get_children():
		if ("List" in ui.name) && ui.visible:
			return ui
