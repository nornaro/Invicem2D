extends TextureButton

var type:String

func _ready() -> void:
	connect("pressed", _on_pressed)
	
func _on_pressed() -> void:
	var node: Node = get_tree().get_first_node_in_group("selected")
	if node:
		get_tree().call_group("selected",type, self)
		return
	get_tree().call_group("Picker", name.to_lower(), self)
