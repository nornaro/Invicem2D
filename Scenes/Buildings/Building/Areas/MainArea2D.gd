extends Area2D

@onready var Castle = $".."
@onready var HealthBar = $"../Control/HealthBar"

func _on_area_entered(area):
	if !area.get_parent().is_in_group("minions"):
		return
	Castle.Data["health"] -= 1
	HealthBar.update()
	area.get_parent().queue_free()
	if Castle.Data["health"] <= 0:
		$"..".queue_free()
#		$"../Control/Warning".text = "Defeat"
