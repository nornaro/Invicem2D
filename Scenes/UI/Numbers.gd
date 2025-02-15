extends ItemList


# Called when the node enters the scene tree for the first time.
func update(s: int) -> void:
	clear()
	for i: int in s:
		add_item(str(i),null,false)
	show()
