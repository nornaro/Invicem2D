extends StaticBody2D

@export var Data = {
	"temp" = false,
	"max_health" = 1000,
	"base_health" = 100,
	"min_health" = 1,
	"health" = 0,
}

func _ready():
	Data["health"] = Data["base_health"]
	get_tree().call_group("HealthBar","value_change",Data["health"])
	get_node("Area2D").remove_from_group("building")

func life_stolen():
	Data["health"] -= 1
	get_tree().call_group("HealthBar","value_change",Data["health"])
	if Data["health"] <= 0:
		queue_free()
	notify_property_list_changed()
