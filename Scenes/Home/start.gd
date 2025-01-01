extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#func _on_tance2D.hide()


func _on_pressed() -> void:
	get_tree().root.get_children()[0].start()
	get_parent().hide()
	pass # Replace with function body.

func _on_mouse_entered() -> void:
	$MeshInstance2D.show()


func _on_mouse_exited() -> void:
	$MeshInstance2D.hide()
