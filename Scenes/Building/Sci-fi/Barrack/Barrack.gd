extends StaticBody2D

@export var Data = {
	"linear_velocity":200
}

func _ready():
	var group = get_parent().name
	add_to_group(group)
	pass

func spawn(Minions,Spawn):
	if is_in_group("temp"):
		return
	var scene = load("res://Scenes/Minions/Minion/minion.tscn")
	var instance = scene.instantiate()
	instance.position = Vector2(Spawn.get_parent().position.x,randi_range(-Spawn.scale.y,Spawn.scale.y))
	instance.linear_velocity = Vector2(-Data["linear_velocity"],0)
	instance.name = str(instance.get_instance_id())
	Minions.add_child(instance)

func _on_area_2d_area_entered(_area):
	pass
	
func _on_area_2d_area_exited(_area):
	pass
	
func _on_area_2d_input_event(_viewport, _event, _shape_idx):
	pass
	
func _on_area_2d_mouse_entered():
	pass
	
func _on_area_2d_mouse_exited():
	pass
