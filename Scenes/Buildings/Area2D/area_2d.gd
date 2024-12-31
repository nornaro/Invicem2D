extends Area2D

var id
var type
var multiselect
#signal selection_toggled(selection)
var selected
signal _menu(selected)
var selection_rectangle = CollisionShape2D.new()

func _input(event):
	if event.is_action_pressed("Ctrl"):
		multiselect = true
	if event.is_action_released("Ctrl"):
		multiselect = false

func set_selected(selection):
	if selection:
		_make_exclusive()
		add_to_group("selected")
		get_parent().get_node("Outline").show()
		return
	remove_from_group("selected")
	get_parent().get_node("Outline").hide()
	selected = selection
#	emit_signal("selection_toggled",selected)

func _make_exclusive() :
	if multiselect:
		return
	get_tree().call_group("selected", "set_selected", false)

func _on_input_event(_viewport, event, _shape_idx):
	if get_tree().get_nodes_in_group("temp"):
		return
	if event.is_action_pressed("LMB"):
		set_selected(!selected)

func _on_area_entered(area):
	if !get_parent().is_in_group("temp"):
		return
	if !area.is_in_group("building"):
		return
	area.add_to_group(str(get_instance_id()))

func _on_area_exited(area):
	area.remove_from_group(str(get_instance_id()))

func _on_mouse_entered():
	pass

func _on_mouse_exited():
	pass
