extends Area2D

#@onready var popup = $"../../UI/ItemList"
#@onready var building = $"../../Building"
#
#func _ready():
#	popup.hide()
#
#func _input(event):
#	if event is InputEventMouseButton and event.pressed:
#		if !popup.visible && !building.instance:
#			popup.position = get_local_mouse_position()
#			popup.show()
