extends Line2D

var saved_building = null

func _ready():
	global_position=get_parent().global_position
	for i in points.size():
		points[i].x *= get_parent().mesh.size.x/2
		points[i].y *= get_parent().mesh.size.y/2

#func _process(delta):
#	if $"../Building".instance:
#		return
#	if $"../Building".selected_building && saved_building != $"../Building".selected_building[0]:
#		points = default
#		hide()
#	if $"../Building".selected_building && $"../Building".selected_building[0] && points[0].x == -1:
#		var selection = instance_from_id($"../Building".selected_building[0])
#		saved_building = $"../Building".selected_building[0]
#		global_position=selection.global_position
#		for i in points.size():
#			points[i].x *= selection.mesh.size.x/2
#			points[i].y *= selection.mesh.size.y/2
#		show()
