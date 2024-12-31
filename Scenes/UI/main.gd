extends OptionButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_option_button_item_selected(index: int) -> void:
	select(-1)
	get_item_text(selected)
	var txt = str(get_item_text(index))
	if get_parent().get_node_or_null(txt):
		get_parent().get_node(txt).show_popup()
		return
	match txt:
		"Exit":
			get_tree().quit(0)
		
