extends Node2D

#LUA/json
@onready var Data = {}

func ready(type):
	Data = JSON.parse_string("res://Scenes/Building/Tower/Turrets//Turret.json")
