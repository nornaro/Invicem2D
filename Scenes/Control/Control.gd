extends Control

@onready var UI = $"../UI"
#@onready var BuildingMenu = $"../UI/BuildingMenuList"
#@onready var TurretList = $"../UI/TurretList"
@onready var Buildings = $"../Buildings"
@export var showCollisionToggle = false
@export var showCollision = false

func _input(event):
	if !UI:
		return
	if event.is_action_pressed("RMB"):
		UI.clear()
	if event.is_action_pressed("Build"):
		UI.clear()
		UI.List.menu("Buildings")
	if event.is_action_pressed("LMB"):
		if UI.active():
			return
		if Buildings.temp_instance:
			return
		#UI.List.menu("Buildings")
						
	if event.is_action_pressed("ShowCollision"):
		showCollision = true
	if event.is_action_released("ShowCollision"):
		showCollision = false	
	if event.is_action_released("ShowCollisionToggle"):
		showCollisionToggle = !showCollisionToggle
