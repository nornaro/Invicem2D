extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func fade_in() -> void:
	$AnimationPlayer.play("fade_to_black")

func fade_out() -> void:
	$VBoxContainer/ProgressBar.value = 0
	$AnimationPlayer.play("fade_to_transparent")
