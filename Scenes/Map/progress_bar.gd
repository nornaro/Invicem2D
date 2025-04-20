extends ProgressBar

func progress(new_value:float) -> void:
	value = new_value*100#lerp(value,new_value,0.2)*100
	if value == 100.0:
		$".".queue_free()
		
		#$"../Black".fade = true
