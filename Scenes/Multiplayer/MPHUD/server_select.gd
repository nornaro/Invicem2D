extends Button

var join_data: String

func set_join_data():
	Global.join_data = join_data
	get_tree().get_first_node_in_group("Join_data").text = join_data
