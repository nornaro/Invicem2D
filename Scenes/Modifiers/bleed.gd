extends Node
class_name Bleed

var Data:Dictionary = {
	"name": "Bleed",
	"type": "Temporary",
	"research": {
		"Academy" : {
			"time": 3,
			"gold": 150,
		},
	},
	"build":  {
		"Forge" : {
			"time": 3,
			"gold": 150,
		},
	"use": "Barrack",
	}
}

@export var bleed_value: int = 1
@export var bleed_percent: int = 1
@onready var minion: Minion = $".."
@onready var bleed_time: int = 1
@onready var bleed_timer: SceneTreeTimer
var physics_time = 0

func _ready() -> void:
	await get_tree().create_timer(bleed_time)
	queue_free()

func _exit_tree() -> void:
	pass

func _physics_process(delta: float) -> void:
	physics_time += delta
	if physics_time >= 1.0:
		minion.Data.HP -= 1
		physics_time = 0
