extends ItemList

@onready var Building = $"../../Building"

@export var menu = {
	"Academy": ["Academy"],
	"Barrack": ["Barrack"],
	"Forge": ["Forge"],
	"Market": ["Market"],
	"Tower": ["Turret >"],
	"Castle": ["Castle"],
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !visible:
		return
	if Building.instance:
		return
	clear()

	if Building.selected_building:
		%UI.get_node("Destroy").choice = Building.selected_building[0]
		%UI.get_node("Destroy").get_node("VBoxContainer/Text").set_text("Destroy the " + instance_from_id(Building.selected_building[0]).get_parent().name + "?")
	for item in menu[instance_from_id(Building.selected_building[0]).get_parent().name]:
		add_item(item)
	show()

func _on_item_selected(_index):
	get_selected_items()
	hide()
