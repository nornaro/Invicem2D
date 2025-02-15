extends AnimatedSprite2D


func set_random() -> void:
	sprite_frames = Global.RL.load(get_meta("sprite_path"))
	set_animation(Global.style)
	var max_frame:int = sprite_frames.get_frame_count(Global.style)-1
	frame = randi_range(0,max_frame)
