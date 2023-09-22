extends Control

@onready var UI = $"../UI"
@onready var BuildingMenu = $"../UI/BuildingMenuList"
@onready var TurretList = $"../UI/TurretList"
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
		builingList()
	if event.is_action_pressed("LMB"):
		if UI.active():
			return
		if Buildings.temp_instance:
			return
		builingList()
						
	if event.is_action_pressed("ShowCollision"):
		showCollision = true
	if event.is_action_released("ShowCollision"):
		showCollision = false	
	if event.is_action_released("ShowCollisionToggle"):
		showCollisionToggle = !showCollisionToggle

func builingList():
		if !UI.fixed: UI.get_node("BuildingList").position = get_local_mouse_position()
		UI.get_node("BuildingList").show()

func _on_building_menu_item_selected(index):
	if BuildingMenu.get_item_text(index) == "Turret >":
		BuildingMenu.hide()
		TurretList.show()
		if !UI.fixed: TurretList.position = BuildingMenu.position
	return
