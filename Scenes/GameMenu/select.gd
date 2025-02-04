extends ItemList

@onready var client2d = preload("res://Scenes/Client/2d_client.tscn") # C
@onready var round_timer = preload("res://Scenes/Timers/round_timer.tscn") # s

func _on_item_selected(index: int) -> void:
	hide()
	if index:
		get_parent().add_child(client2d.instantiate())
		return
	get_parent().add_child(round_timer.instantiate())
