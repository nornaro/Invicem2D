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
	print(Buildings.selected_building)
	for building in Buildings.selected_building:
		print(instance_from_id(building).get_parent().name)
		instance_from_id(building).queue_free()
	Buildings.selected_building.clear()
	hide()
