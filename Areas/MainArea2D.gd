extends Area2D

@onready var main = $".."
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_area_entered(area):
	if area.get_parent().is_in_group("minions"):  # Assuming you've added minions to the "minions" group
		main.health -= 1
		print("Main building health: ", main.health)
		area.get_parent().queue_free()
		$"../../../Barrack".mobcount -= 1
		if main.health <= 0:
			$"..".queue_free()
			$"../Control/Warning".text = "Defeat"
