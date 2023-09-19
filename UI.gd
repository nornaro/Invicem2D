extends Node

@export var fixed = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):	
	pass
	
func clear():
	for ui in get_children():
		if "List" in ui.name || "Menu" in ui.name:
			ui.deselect_all()
		ui.hide()

func active():	
	for ui in get_children():
		if ("List" in ui.name || "Menu" in ui.name) && ui.visible:
			return ui
