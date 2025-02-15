extends Panel

#@onready var choice = null
#@onready var confirm = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("VBoxContainer/VBoxContainer/Text").set_text("[center]\nDestroy the building(s)?[/center]")

func _input(_event: InputEvent) -> void:
	if visible:
		if Input.is_key_pressed(KEY_ENTER):
			_on_confirm_pressed()
		if Input.is_key_pressed(KEY_ESCAPE):
			get_tree().call_group("Outline", "hide")
			hide()
		return
	if Input.is_key_pressed(KEY_DELETE):
		if get_tree().get_nodes_in_group("selected"):
			show()
			return

func _on_confirm_pressed() -> void:
	for building in get_tree().get_nodes_in_group("selected"):
		building.get_parent().queue_free()
	hide()

func _on_cancel_pressed() -> void:
	hide()
