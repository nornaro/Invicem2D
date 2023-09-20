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

func _on_item_selected(_index):
	get_selected_items()
	hide()
