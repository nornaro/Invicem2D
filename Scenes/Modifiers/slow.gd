extends Node
class_name Slow

@export var slow_value_a: int = 1
@export var slow_percent: int = 1
@export var slow_value_b: int = 1
@export var change: int = 0
@onready var minion: Minion = $".."
@onready var og: float

func _ready() -> void:
	minion.Data.Speed -= slow_value_a
	minion.Data.Speed *= 100 - slow_percent
	minion.Data.Speed -= slow_value_b

func _exit_tree() -> void:
	minion.Data.Speed += slow_value_a
	minion.Data.Speed /= 100 - slow_percent
	minion.Data.Speed += slow_value_b
