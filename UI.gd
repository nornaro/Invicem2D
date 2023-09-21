extends Node

@export var fixed = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
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
