extends Area2D

@onready var Castle = $".."
@onready var HealthBar = $"../Control/HealthBar"

func _on_area_entered(area):
	if !area.get_parent().is_in_group("minions"):
		return  # Assuming you've added minions to the "minions" group
	Castle.Data["health"] -= 1
	HealthBar.update()
	#print("Main building health: ", Castle.Data["health"])
	area.get_parent().queue_free()
	if Castle.Data["health"] <= 0:
		$"..".queue_free()
#		$"../Control/Warning".text = "Defeat"
