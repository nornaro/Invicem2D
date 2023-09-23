extends MeshInstance2D

@export var Data = {
	"temp" = false,
	"max_health" = 1000,
	"base_health" = 100,
	"min_health" = 1,
	"health" = 0,
}

func _ready():
	Data["health"] = Data["base_health"]
	texture = load("res://Scenes/Buildings/Building/"+get_parent().name+".png")
	modulate = Color(1, 1, 1, 1)
	$Control/HealthBar.update()
