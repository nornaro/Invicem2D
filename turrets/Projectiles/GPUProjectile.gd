extends GPUParticles2D

var target_speed: Vector2 = Vector2(0, -100) # Example value; replace with your target's speed and direction.

func _ready():
	emit_towards_target(Vector2(500, 500), Vector2(700, 300), target_speed)

func emit_towards_target(emission_point: Vector2, target_position: Vector2, target_speed: Vector2):
	var direction_to_target = (target_position - emission_point).normalized()
	var estimated_target_position = target_position + direction_to_target * target_speed.length()
	var estimated_direction = (estimated_target_position - emission_point).normalized()
	
	var mat = process_material as StandardMaterial3D
	if mat:
		mat.set_shader_param("initial_velocity", estimated_direction * 500) # 500 is an example speed; adjust as needed.
	
	global_position = emission_point
	emitting = true
