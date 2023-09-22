extends Line2D

var saved_building = null

func _ready():
	global_position=get_parent().global_position
	for i in points.size():
		points[i].x *= get_parent().mesh.size.x/2
		points[i].y *= get_parent().mesh.size.y/2
