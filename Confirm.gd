extends Panel

@onready var choice = null
@onready var confirm = null
@onready var Building = $"../../Building"

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("VBoxContainer/Text").set_text("Destroy the building(s)?")
	pass # Replace with function body.

func _input(event):
	if visible:
		if Input.is_key_pressed(KEY_ENTER):
			_on_confirm_pressed()

func _on_confirm_pressed():
	for building in Building.selected_building:
		instance_from_id(building).queue_free()
	Building.selected_building.clear()
	%UI.clear()
