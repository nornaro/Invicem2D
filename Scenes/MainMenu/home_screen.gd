extends Panel


func _ready() -> void:
	var directories:Array = Global.RL.get_directories_at("res://Scenes/MainMenu/HomeButtons/")
	for dir:String in directories:
		var data:Array =  dir.split("_")
		get_node(data[0]).load_buttons(data)
	set_process(false)

var time_to_black : float = 5.0  # Time to transition to black
var time_to_transparent : float = 5.0  # Time to transition to transparent
var current_time : float = 0.0  # Time counter
var step:int = 0

func _process(delta: float) -> void:
	get_tree().call_group("Homs_Screen_Button","hide")
	if step == 0:
		modulate = lerp(modulate, Color.BLACK, delta)
	if modulate.r <= 0.01:
		step = 1
	if step == 1:
		modulate.a = lerp(modulate.a, 0.0, delta)
	if modulate.a <= 0.01:
		var cam:Camera2D = get_tree().get_first_node_in_group("Camera2")
		if cam:
			cam.make_current()
		queue_free()
