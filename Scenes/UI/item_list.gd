extends ItemList

@onready var menu:PackedScene = preload("res://Scenes/UI/item_list.tscn")

func _enter_tree() -> void:
	connect("item_clicked",on_item_clicked)
	if name != "ItemList":
		return

func on_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	if name == "submenu":
		return
	main(index)
	
func main(index:int) -> void:
	get_tree().call_group("ProjectilePropertyList","hide")
	var data: Dictionary = {get_parent().tooltip_text:get_item_text(index)}
	var _first: Node = get_tree().get_first_node_in_group("selected")
	#if first.Data.has(data):
		#if first.Data[data] is Dictionary:
			#$submenu.show()
			#$submenu.clear()
			#for upgrade in first.Data.Upgrades:
				#$submenu.add_item(upgrade)
	get_tree().call_group("selected","set_data",data)
	##2DO show submenu with properties, after that show asc/desc

func _on_mouse_exited() -> void:
	get_tree().call_group("ProjectilePropertyList","hide")
	
func submenu_clicked(_index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	pass
	
func submenu(index:int) -> void:
	if get_item_text(index).contains("max") or get_item_text(index).contains("min"):
		clear()
		add_item("Min")
		add_item("Max")
		
