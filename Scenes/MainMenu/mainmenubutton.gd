@tool
extends Button

var ready_check = []
@onready var main_circle = preload("res://Scenes/HomeScreen/main_circle.tscn")

func _ready() -> void:
	
	text = name
	#ready_check = get_tree().get_nodes_in_group("Ready")

func _on_pressed() -> void:
	match name:
		"Start":
			get_tree().call_group("Client","start")
			get_parent().hide()
		"Exit":
			get_tree().quit()
		"Style":
			pass


func _on_mouse_entered() -> void:
	$MeshInstance2D.show()


func _on_mouse_exited() -> void:
	$MeshInstance2D.hide()


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		$MainCircle.position = $"../Marker2D".position
		text = name


func _on_main_circle_pressed() -> void:
	get_tree().call_group("MainCircle","hide")
	show()
