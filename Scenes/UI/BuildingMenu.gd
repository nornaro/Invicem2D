extends ItemList

@export var menu = {
	"Academy": ["Academy"],
	"Barrack": ["Barrack"],
	"Forge": ["Forge"],
	"Market": ["Market"],
	"Tower": ["Turret >"],
	"Castle": ["Castle"],
}

func _on_item_selected(_index):
	hide()
