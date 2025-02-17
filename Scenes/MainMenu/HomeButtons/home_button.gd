@tool
extends Button

var ready_check:Array = []
@onready var main_circle:PackedScene = preload("main_circle.tscn")

func _ready() -> void:
	add_to_group("Homs_Screen_Button")


func _on_mouse_entered() -> void:
	$Bubble.show()


func _on_mouse_exited() -> void:
	$Bubble.hide()

func _on_pressed() -> void:
	get_tree().call_group("MainCircle","hide")
	if $MainCircle:
		$MainCircle.show()
	#get_tree().call_group(name,"main")

func load_buttons(data: Array) -> void:
	var instance:Node = main_circle.instantiate()
	add_child(instance)
	name = data[1]
	text = name
	#$MainCircle.add_to_group(name)
	$MainCircle.load_buttons(data)
	#$MainCircle.set_script(get_script().resource_path.get_base_dir()+"/"+data[0]+"_"+data[1]+"/script.gd")

	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().call_group("MainCircle","hide")
