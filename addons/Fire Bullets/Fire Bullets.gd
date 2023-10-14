@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("Gun","Node2D",preload("scripts/Gun.gd"),preload("assets/gun.svg"))
	add_custom_type("Bullet","Area2D",preload("scripts/Bullet.gd"),preload("assets/bullet.png"))
	pass


func _exit_tree():
	# Clean-up of the plugin goes here.
	pass
