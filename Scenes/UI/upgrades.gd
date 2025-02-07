extends TextureButton

@export var right: String
@export var left: String


func _ready() -> void:
	connect("pressed",_on_pressed)

func _on_pressed() -> void:
	var node = get_tree().get_first_node_in_group("selected")
	if !node:
		return
	get_tree().call_group("selected","upgrade", tooltip_text)
	var value = node.get_parent().Data.Upgrades[tooltip_text]
