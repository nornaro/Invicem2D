@tool
extends Button

var ready_check = []
@onready var main_circle = preload("res://Scenes/HomeScreen/HomeButtons/main_circle.tscn")

#
#func _on_pressed() -> void:
	#match name:
		#"Start":
			#get_tree().call_group("Client","start")
			#get_parent().hide()
		#"Exit":
			#get_tree().quit()
		#"Style":
			#pass


func _on_mouse_entered() -> void:
	$Bubble.show()


func _on_mouse_exited() -> void:
	$Bubble.hide()


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		text = name


func _on_pressed() -> void:
	get_tree().call_group("MainCircle","hide")
	$MainCircle.show()

func load_buttons(data: Array) -> void:
	add_child(main_circle.instantiate())
	name = data[1]
	text = name
	$MainCircle.load_buttons(data)
