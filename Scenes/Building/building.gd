extends MeshInstance2D

@export var Data = {}

func _ready():
	mesh = PlaneMesh.new()
	mesh.orientation=mesh.FACE_Z
	add_to_group(get_parent().name)
	texture = load("res://Scenes/Building/"+get_parent().name+"/"+get_parent().name+".png")
	mesh.size = texture.get_size()
	scale = Vector2(100 / mesh.size.x, -100 / mesh.size.y)
	var id = get_node_or_null("ID")
	if id:
		id.text = str(get_instance_id())
		id.size.x = mesh.size.x
		id.position.x = -mesh.size.x/2
	$Area2D.scale.x = mesh.size.x*0.8
	$Area2D.scale.y = mesh.size.y*0.7
	for i in $Outline.points.size():
		$Outline.points[i] *= mesh.size/2
	$Outline.scale = Vector2(1,1)
	notify_property_list_changed()

func clear_collision():
	for area in get_tree().get_nodes_in_group(str($Area2D.get_instance_id())):
		area.remove_from_group(str($Area2D.get_instance_id()))
