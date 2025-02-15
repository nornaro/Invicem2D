extends TextureButton

func _ready() -> void:
	connect("pressed",_on_pressed)
	
func _on_pressed() -> void:
	get_tree().call_group("ProjectilePropertyList","hide")
	if !get_tree().get_node_count_in_group("selected"):
		return
	var itemlist: Node = get_child(0)
	itemlist.global_position = global_position - Vector2(itemlist.size.x*2/3,0)
	itemlist.show()
	
