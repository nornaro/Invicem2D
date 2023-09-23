extends Panel

@onready var choice = null
@onready var confirm = null
@onready var Buildings = $"../../Buildings"

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("VBoxContainer/Text").set_text("Destroy the building(s)?")
	pass # Replace with function body.

func _input(_event):
	if visible:
		if Input.is_key_pressed(KEY_ENTER):
			_on_confirm_pressed()

func _on_confirm_pressed():	
	for building in get_tree().get_nodes_in_group("BuildingMesh"):
		if !building.Data.has("selected"):
			hide()
			return
		building.queue_free()
	hide()
