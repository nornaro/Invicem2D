extends VBoxContainer

@onready var server_list = $ServerList
@onready var refresh_button = $RefreshButton

func _ready():
	refresh_button.pressed.connect(get_parent().update_server_list)

func update_server_list(servers: Array):
	server_list.clear()
	for server in servers:
		server_list.add_item(server)

func _on_ServerList_item_selected(index: int):
	var selected = server_list.get_item_text(index)
	get_parent().join_server(selected)
