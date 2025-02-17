extends StaticBody2D

@export var Data: Dictionary = {
	"temp": false,
	"max_health": 1000,
	"base_health": 100,
	"min_health": 1,
	"health": 0,
	"Info": {},
	"Properties": {},
	"Modules": {},
	"Inventory": {},
	"Upgrades":{},
}

func _ready() -> void:
	Data["health"] = Data["base_health"]
	get_tree().call_group("HealthBar","value_change",Data["health"])
	get_node("Area").remove_from_group("building")

func life_stolen() -> void:
	Data["health"] -= 1
#	get_tree().call_group("Network","rpc_id","life_stolen",multiplayer.get_unique_id())
	get_tree().call_group("HealthBar","value_change",Data["health"])
	if Data["health"] <= 0:
		queue_free()
	notify_property_list_changed()
