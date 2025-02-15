extends Area2D

var type:String
var multiselect:bool=false
var selected:bool = false
var selection_rectangle:CollisionShape2D = CollisionShape2D.new()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Ctrl"):
		multiselect = true
	if event.is_action_released("Ctrl"):
		multiselect = false

func set_data(data: Dictionary) -> void:
	var parent:Node = get_parent()
	parent.Data.Properties.merge(data,true)
	if data.has("Targeting"):
		parent.set_targeting()
		
func upgrade(data: String) -> void:
	var value:int = 1
	if Input.is_key_pressed(KEY_CTRL):
		value = 16
	var parent:Node = get_parent()
	if parent.Data.Upgrades[data] >= 16:
		return
	parent.Data.Upgrades[data] = clamp(parent.Data.Upgrades[data]+value ,parent.Data.Upgrades[data], 16)

func set_selected(selection:bool) -> void:
	if selection:
		_make_exclusive()
		add_to_group("selected")
		get_tree().call_group("BuildingProperties","fill")
		get_parent().get_node("Outline").show()
		return
	remove_from_group("selected")
	get_tree().call_group("BuildingProperties","clear")
	if get_tree().get_node_count_in_group("selected"):
		get_tree().call_group("BuildingProperties","fill")
	get_parent().get_node("Outline").hide()
	selected = selection
#	emit_signal("selection_toggled",selected)

func _make_exclusive() -> void:
	if multiselect:
		return
	get_tree().call_group("selected", "set_selected", false)

func _on_input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if get_tree().get_nodes_in_group("temp"):
		return
	if event.is_action_pressed("LMB"):
		set_selected(!selected)

func _on_area_entered(area:Area2D) -> void:
	if !get_parent().is_in_group("temp"):
		return
	if !area.is_in_group("building"):
		return
	area.add_to_group(str(get_instance_id()))

func _on_area_exited(area:Area2D) -> void:
	area.remove_from_group(str(get_instance_id()))
