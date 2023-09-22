extends TextEdit

func _ready():
	text = str(get_parent().get_instance_id())
