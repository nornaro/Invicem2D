extends Panel

@onready var choice = null
@onready var confirm = null
@onready var Building = $"../../Building"

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("VBoxContainer/Text").set_text("Destroy the building(s)?")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		if Input.is_key_pressed(KEY_ENTER):
			_on_confirm_pressed()
		if Input.is_key_pressed(KEY_ESCAPE):
			_on_cancel_pressed()	
			
func _on_cancel_pressed():
	$".".hide()

func _on_confirm_pressed():
	for building in Building.selected_building:
		instance_from_id(building).queue_free()
	Building.selected_building.clear()
	$".".hide()
