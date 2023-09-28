extends RigidBody2D

@export var Data = {
	"speed" : 5,
	"hp" : 100,
	"def" : 100,
	"dodge" : 100
}
var max_hp

func _ready():
	gravity_scale = 0
	max_hp=Data["hp"]
	$hpBar.max_value=Data["hp"]

func _physics_process(delta):
	if get_tree().get_nodes_in_group("true").size()>0:
		return
	if rotation != 0:
		if rotation > 0+delta:
			rotation -= delta
		if rotation < 0-delta:
			rotation += delta
		if abs(rotation) < delta:
			rotation = 0

	notify_property_list_changed()	
	
func hurt():
#	$hpBar.add_theme_color_override("theme_override_style/fill",Color(1,0,0))
	$hpBar.modulate = Color(1,(Data["hp"]/max_hp)*(Data["hp"]/max_hp),0,0.75)
	$hpBar.value=Data["hp"]
	notify_property_list_changed()
