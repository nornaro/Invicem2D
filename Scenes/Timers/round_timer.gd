extends Timer

func _ready() -> void:
	start()

func _on_timeout() -> void:
	if Global.mp:
		spawn.rpc(Global.clients,{})
		return
	get_tree().call_group("Barrack","spawn",{})
	

@rpc("authority", "call_remote", "reliable")
func spawn(_clients: Dictionary) -> void:
	pass
