extends Panel

func _ready() -> void:
	$VBoxContainer/HBoxContainer/Confirm.connect("pressed",_on_confirm_pressed)
	$VBoxContainer/HBoxContainer/Cancel.connect("pressed",_on_cancel_pressed)
	
func _on_confirm_pressed() -> void:
	get_tree().quit()


func _on_cancel_pressed() -> void:
	hide()
