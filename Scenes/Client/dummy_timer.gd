extends Node

func _ready() -> void:
	pass

func _on_timeout() -> void:
	pass

@rpc("authority", "call_remote", "reliable")
func spawn():
	get_tree().call_group("Barrack", "spawn")
