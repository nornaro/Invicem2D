extends ItemList

@onready var home = preload("res://Scenes/Home/home_screen.tscn")
@onready var server = preload("res://Scenes/Server/server.tscn")
@onready var client2d = preload("res://Scenes/Client/2d_client.tscn")
@onready var round_timer = preload("res://Scenes/Main/round_timer.tscn")

func _on_item_selected(index: int) -> void:
	hide()
	if index:
		get_parent().add_child(client2d.instantiate())
		get_parent().add_child(home.instantiate())
		return
	get_parent().add_child(server.instantiate())
	get_parent().add_child(round_timer.instantiate())
